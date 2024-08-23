CREATE TABLE [dbo].[uncertainty] (
    [id]          INT        IDENTITY (1, 1) NOT NULL,
    [value_min]   FLOAT (53) NOT NULL,
    [value_max]   FLOAT (53) NOT NULL,
    [uncertainty] FLOAT (53) NOT NULL,
    [analysis]    INT        NOT NULL,
    CONSTRAINT [PK_uncertainty] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_uncertainty_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[uncertainty_insert_update]
   ON  [dbo].[uncertainty]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @min FLOAT
	DECLARE @max FLOAT

	SET @min = (SELECT value_min FROM inserted)
	SET @max = (SELECT value_max FROM inserted)

	IF (SELECT value_max FROM inserted) < (SELECT value_min FROM inserted)
		THROW 51000, 'value_max is smaller value_min', 1

	IF NOT (SELECT value_min FROM inserted) < (SELECT MIN(value_min) FROM uncertainty WHERE analysis = (SELECT analysis FROM inserted) AND value_max > (SELECT value_min FROM inserted) AND id <> (SELECT id FROM inserted))
		THROW 51000, 'value_min already covered', 1	
	
	IF NOT (SELECT value_max FROM inserted) <= (SELECT MIN(value_min) FROM uncertainty WHERE analysis = (SELECT analysis FROM inserted) AND value_min > (SELECT value_min FROM inserted) AND id <> (SELECT id FROM inserted))
		THROW 51000, 'value_max already covered', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[uncertainty_audit]
   ON  [dbo].[uncertainty]
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
