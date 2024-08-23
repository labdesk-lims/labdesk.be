CREATE TABLE [dbo].[method_analysis] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [method]   INT NOT NULL,
    [analysis] INT NOT NULL,
    [applies]  BIT CONSTRAINT [DF_method_analysis_applies] DEFAULT ((0)) NOT NULL,
    [standard] BIT CONSTRAINT [DF_method_analysis_standard] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_method_analysis] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_method_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_method_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_analysis_insert_update]
   ON  [dbo].[method_analysis]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		IF (SELECT COUNT(*) FROM method_analysis WHERE analysis = (SELECT analysis FROM inserted) AND standard = 1) > 1
			THROW 51000, 'One standard method allowed only.', 1
	END
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_analysis_audit]
   ON  [dbo].[method_analysis]
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
