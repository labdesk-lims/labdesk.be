CREATE TABLE [dbo].[template_profile] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [template] INT NOT NULL,
    [profile]  INT NULL,
    [priority] INT NULL,
    [workflow] INT NOT NULL,
    [smppoint] INT NULL,
    CONSTRAINT [PK_template_profile] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_template_profile_priority] FOREIGN KEY ([priority]) REFERENCES [dbo].[priority] ([id]),
    CONSTRAINT [FK_template_profile_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]),
    CONSTRAINT [FK_template_profile_smppoint] FOREIGN KEY ([smppoint]) REFERENCES [dbo].[smppoint] ([id]),
    CONSTRAINT [FK_template_profile_template] FOREIGN KEY ([template]) REFERENCES [dbo].[template] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_template_profile_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2025 May
-- Description:	-
-- =============================================
CREATE TRIGGER template_profile_audit 
   ON  template_profile
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
