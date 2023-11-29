CREATE TABLE [dbo].[role] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [title]          VARCHAR (255)  NULL,
    [description]    NVARCHAR (MAX) NULL,
    [hourly_rate]    MONEY          CONSTRAINT [DF_role_hourly_rate] DEFAULT ((0)) NOT NULL,
    [administrative] BIT            CONSTRAINT [DF_role_adminrole] DEFAULT ((0)) NOT NULL,
    [deactivate]     BIT            CONSTRAINT [DF_role_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_role] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[role_insert_update]
   ON  dbo.role 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (SELECT COUNT(*) FROM role WHERE administrative = 1) > 1
		THROW 51000, 'Only one administrative role allowed.', 1

    -- Insert statements for trigger here
	DECLARE @role INT
	SET @role = (SELECT id FROM inserted)
	INSERT INTO role_permission (role, permission)
	SELECT @role, id FROM permission WHERE id NOT IN (SELECT DISTINCT(role_permission.permission) FROM role_permission WHERE role = @role)
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[role_audit]
   ON  dbo.role
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
