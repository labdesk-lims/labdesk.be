CREATE TABLE [dbo].[measurement_condition] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [value_txt]   NVARCHAR (MAX) NULL,
    [value_num]   FLOAT (53)     NULL,
    [condition]   INT            NOT NULL,
    [measurement] INT            NOT NULL,
    CONSTRAINT [PK_measurement_condition] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_measurement_condition_condition] FOREIGN KEY ([condition]) REFERENCES [dbo].[condition] ([id]),
    CONSTRAINT [FK_measurement_condition_measurement] FOREIGN KEY ([measurement]) REFERENCES [dbo].[measurement] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_condition_audit] 
   ON  [dbo].[measurement_condition]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @table_name nvarchar(256)
	DECLARE @table_id INT
	DECLARE @action_type char(1)
	DECLARE @inserted xml, @deleted xml

	IF NOT EXISTS(SELECT 1 FROM deleted) AND NOT EXISTS(SELECT 1 FROM inserted) 
    RETURN;

	-- Get table infos
	SELECT @table_name = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID)

	-- Get action
	IF EXISTS (SELECT * FROM inserted)
		BEGIN
			SELECT @table_id = id FROM inserted
			IF EXISTS (SELECT * FROM deleted)
				SELECT @action_type = 'U'
			ELSE
				SELECT @action_type = 'I'
		END
	ELSE
		BEGIN
			SELECT @table_id = id FROM deleted
			SELECT @action_type = 'D'
		END

	-- Create xml log
	SET @inserted = (SELECT * FROM inserted FOR XML PATH)
	SET @deleted = (SELECT * FROM deleted FOR XML PATH)

	-- Insert log
    INSERT INTO audit(table_name, table_id, action_type, changed_by, value_old, value_new)
    SELECT @table_name, @table_id, @action_type, SUSER_SNAME(), @deleted, @inserted
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_condition_update]
   ON  [dbo].[measurement_condition]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @value_changed BIT
	DECLARE @state CHAR(2)
	DECLARE @t TABLE(id INT IDENTITY(1,1) PRIMARY KEY, value NVARCHAR(256))

	-- Check if state allow capturing
	SET @state = (SELECT state FROM measurement INNER JOIN measurement_condition ON measurement.id = measurement_condition.measurement WHERE measurement_condition.id = (SELECT id FROM inserted))
	IF @state <> 'CP' 
		THROW 51000, 'Not able to capture. State does not match CP.', 1

	-- Set value changed bit
	IF (SELECT value_txt FROM inserted) <> (SELECT value_txt FROM deleted) OR (SELECT value_num FROM inserted) <> (SELECT value_num FROM deleted) OR ((SELECT value_num FROM inserted) IS NOT NULL AND (SELECT value_num FROM deleted) IS NULL) OR (((SELECT value_txt FROM inserted) IS NOT NULL AND (SELECT value_txt FROM deleted) IS NULL))
			SET @value_changed = 1
		ELSE
			SET @value_changed = 0

	-- Set value_txt in case of attribute results
	IF (SELECT type FROM condition WHERE id = (SELECT condition FROM inserted)) = 'A'
	BEGIN
		INSERT INTO @t (value) SELECT value FROM STRING_SPLIT( (SELECT attributes FROM condition WHERE id = (SELECT condition FROM inserted)) , ',')
		UPDATE measurement_condition SET value_txt = (SELECT value FROM @t WHERE id = (SELECT value_num FROM inserted)) WHERE id = (SELECT id FROM inserted)
	END

	-- Set value_txt in case of numeric values
	IF (SELECT type FROM condition WHERE id = (SELECT condition FROM inserted)) = 'N'
	BEGIN
		UPDATE measurement_condition SET value_txt = (SELECT value_num FROM inserted) WHERE id = (SELECT id FROM inserted)
	END
END
