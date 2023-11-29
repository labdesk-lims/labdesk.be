CREATE TABLE [dbo].[strposition] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [position]   VARCHAR (255) NULL,
    [request]    INT           NULL,
    [material]   INT           NULL,
    [batch_id]   VARCHAR (255) NULL,
    [opened_on]  DATETIME      NULL,
    [expiration] DATETIME      NULL,
    [container]  INT           NULL,
    [amount]     FLOAT (53)    NULL,
    [unit]       VARCHAR (255) NULL,
    [storage]    INT           NOT NULL,
    CONSTRAINT [PK_strposition] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_strposition_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]),
    CONSTRAINT [FK_strposition_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]),
    CONSTRAINT [FK_strposition_smpcontainer] FOREIGN KEY ([container]) REFERENCES [dbo].[smpcontainer] ([id]),
    CONSTRAINT [FK_strposition_storage] FOREIGN KEY ([storage]) REFERENCES [dbo].[storage] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[strpostion_insert_update]
   ON  [dbo].[strposition]
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(*) FROM strposition WHERE storage = (SELECT storage FROM inserted) AND request = (SELECT request FROM inserted) AND (SELECT request FROM inserted) IS NOT NULL AND id <> (SELECT id FROM inserted)) > 0
		THROW 51000, 'Already stored.', 1

	IF (SELECT COUNT(*) FROM strposition WHERE storage = (SELECT storage FROM inserted) AND position = (SELECT position FROM inserted) AND (SELECT id FROM inserted) <> id) > 0
		THROW 51000, 'Position already created.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[strposition_audit]
   ON  [dbo].[strposition] 
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
