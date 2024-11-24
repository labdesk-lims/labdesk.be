CREATE TABLE [dbo].[template] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [customer]        INT            NOT NULL,
    [title]           VARCHAR (255)  NULL,
    [description]     NVARCHAR (MAX) NULL,
    [client_order_id]  VARCHAR (255)   NULL,
    [priority]        INT            NOT NULL,
    [workflow]        INT            NOT NULL,
    [report_template] VARCHAR (255)  NULL,
    [deactivate]      BIT            CONSTRAINT [DF_template_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_template] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_template_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]),
    CONSTRAINT [FK_template_customer1] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]),
    CONSTRAINT [FK_template_priority] FOREIGN KEY ([priority]) REFERENCES [dbo].[priority] ([id]),
    CONSTRAINT [FK_template_workflow] FOREIGN KEY ([workflow]) REFERENCES [dbo].[workflow] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2025 May
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[template_audit] 
   ON  dbo.template 
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
