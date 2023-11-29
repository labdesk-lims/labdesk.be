CREATE TABLE [dbo].[attachment] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [title]            VARCHAR (255)   NULL,
    [file_name]        NVARCHAR (MAX)  NULL,
    [version_control]  BIT             CONSTRAINT [DF_attachment_version_control] DEFAULT ((0)) NULL,
    [reminder]         DATETIME        NULL,
    [responsible]      INT             NULL,
    [revision]         DATETIME        NULL,
    [repetition]       INT             NULL,
    [upload_by]        VARCHAR (255)   NULL,
    [upload_at]        DATETIME        NULL,
    [attach]           BIT             CONSTRAINT [DF_attachment_attach] DEFAULT ((0)) NOT NULL,
    [blob]             VARBINARY (MAX) NULL,
    [certificate]      INT             NULL,
    [qualification]    INT             NULL,
    [request]          INT             NULL,
    [method]           INT             NULL,
    [instrument]       INT             NULL,
    [customer]         INT             NULL,
    [manufacturer]     INT             NULL,
    [supplier]         INT             NULL,
    [material]         INT             NULL,
    [service]          INT             NULL,
    [project]          INT             NULL,
    [task]             INT             NULL,
    [billing_customer] INT             NULL,
    CONSTRAINT [PK_attachment] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_attachment_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_instrument_certificate] FOREIGN KEY ([certificate]) REFERENCES [dbo].[certificate] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_manufacturer] FOREIGN KEY ([manufacturer]) REFERENCES [dbo].[manufacturer] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_qualification] FOREIGN KEY ([qualification]) REFERENCES [dbo].[qualification] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_request] FOREIGN KEY ([request]) REFERENCES [dbo].[request] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_attachment_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]),
    CONSTRAINT [FK_attachment_users] FOREIGN KEY ([responsible]) REFERENCES [dbo].[users] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Version control validity check
-- ==============================================
CREATE TRIGGER [dbo].[attachment_update]
   ON  dbo.attachment
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1 AND ((SELECT reminder FROM inserted) = NULL OR (SELECT responsible FROM inserted) = NULL OR (SELECT repetition FROM inserted) = NULL)
		THROW 51000, 'Version control needs reminder, revision and repetion values to be set.', 1 

	IF (SELECT version_control FROM inserted) = 1 AND (SELECT revision FROM inserted) <> (SELECT revision FROM deleted)
		UPDATE attachment SET reminder = DateAdd(day, (SELECT repetition FROM inserted), GetDate()) WHERE id = (SELECT id FROM inserted)
END

GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[attachment_insert] 
   ON  dbo.attachment
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1 AND ((SELECT reminder FROM inserted) = NULL OR (SELECT responsible FROM inserted) = NULL OR (SELECT repetition FROM inserted) = NULL)
		THROW 51000, 'Version control needs reminder, revision and repetion values to be set.', 1 
END

GO
-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Audit trail support in case of
-- version control
-- ==================================================
CREATE TRIGGER [dbo].[attachment_audit]
   ON  dbo.attachment
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT version_control FROM inserted) = 1
	BEGIN
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
END
