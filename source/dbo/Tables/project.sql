CREATE TABLE [dbo].[project] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [profile]     INT            NULL,
    [owner]       VARCHAR (255)  CONSTRAINT [DF_project_owner] DEFAULT (suser_name()) NOT NULL,
    [started]     BIT            CONSTRAINT [DF_project_started] DEFAULT ((0)) NULL,
    [deactivate]  BIT            CONSTRAINT [DF_project_deactivate] DEFAULT ((0)) NULL,
    [customer]    INT            NULL,
    [invoice]     BIT            CONSTRAINT [DF_project_invoice] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_project] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_project_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]),
    CONSTRAINT [FK_project_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 June
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[project_insert]
   ON  [dbo].[project]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	-- Insert custom fields
	INSERT INTO project_customfield (field_name, project) SELECT field_name, (SELECT id FROM inserted) FROM customfield WHERE table_name = 'project'

END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[project_audit]
   ON  dbo.project
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
