CREATE TABLE [dbo].[measurement_cfield] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [value_num]   FLOAT (53) NULL,
    [cfield]      INT        NOT NULL,
    [measurement] INT        NOT NULL,
    CONSTRAINT [PK_measurement_cfield] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_measurement_cfield_cfield] FOREIGN KEY ([cfield]) REFERENCES [dbo].[cfield] ([id]),
    CONSTRAINT [FK_measurement_cfield_measurement] FOREIGN KEY ([measurement]) REFERENCES [dbo].[measurement] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_cfield_audit]
   ON  [dbo].[measurement_cfield] 
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
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[measurement_cfield_update]
   ON  [dbo].[measurement_cfield] 
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		DECLARE @state CHAR(2)

		-- Check if state allow capturing
		SET @state = (SELECT state FROM measurement INNER JOIN measurement_cfield ON measurement.id = measurement_cfield.measurement WHERE measurement_cfield.id = (SELECT id FROM inserted))
		IF @state <> 'CP' 
			THROW 51000, 'Not able to capture. State does not match CP.', 1
	END
END
