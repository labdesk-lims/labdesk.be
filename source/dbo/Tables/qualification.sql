CREATE TABLE [dbo].[qualification] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [title]         VARCHAR (255)  NULL,
    [description]   NVARCHAR (MAX) NULL,
    [creation_date] DATETIME       NULL,
    [valid_from]    DATETIME       NOT NULL,
    [valid_till]    DATETIME       NOT NULL,
    [performed_by]  INT            NULL,
    [user_id]       INT            NOT NULL,
    [withdraw]      BIT            CONSTRAINT [DF_method_qualification_withdraw] DEFAULT ((0)) NULL,
    [method]        INT            NOT NULL,
    CONSTRAINT [PK_method_user] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_method_qualification_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]),
    CONSTRAINT [FK_method_qualification_users] FOREIGN KEY ([user_id]) REFERENCES [dbo].[users] ([id]),
    CONSTRAINT [FK_qualification_contact] FOREIGN KEY ([performed_by]) REFERENCES [dbo].[contact] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[qualification_insert_update]
   ON  dbo.qualification 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT valid_from FROM inserted) > (SELECT valid_till FROM inserted)
		THROW 51000, 'Wrong qualification dates.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[quaification_audit]
   ON  [dbo].[qualification] 
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
