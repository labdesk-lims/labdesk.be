CREATE TABLE [dbo].[users] (
    [id]       INT              IDENTITY (1, 1) NOT NULL,
    [name]     VARCHAR (255)    NOT NULL,
    [uid]      UNIQUEIDENTIFIER CONSTRAINT [DF_users_uid] DEFAULT (newid()) NULL,
	[uak]	   NVARCHAR(max),
    [role]     INT              NULL,
    [contact]  INT              NULL,
    [language] VARCHAR (32)     CONSTRAINT [DF_users_language] DEFAULT (N'en') NOT NULL,
    CONSTRAINT [PK_users_name] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_users_contact] FOREIGN KEY ([contact]) REFERENCES [dbo].[contact] ([id]),
    CONSTRAINT [FK_users_role] FOREIGN KEY ([role]) REFERENCES [dbo].[role] ([id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_users]
    ON [dbo].[users]([name] ASC);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER users_audit 
   ON  users
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
