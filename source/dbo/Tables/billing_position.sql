CREATE TABLE [dbo].[billing_position] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [category]         INT            NULL,
    [profile]          INT            NULL,
    [method]           INT            NULL,
    [analysis]         INT            NULL,
    [material]         INT            NULL,
    [service]          INT            NULL,
    [other]            NVARCHAR (MAX) NULL,
    [amount]           INT            NOT NULL,
    [price]            MONEY          NOT NULL,
    [billing_customer] INT            NOT NULL,
    CONSTRAINT [PK_billing_position] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_billing_position_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]),
    CONSTRAINT [FK_billing_position_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_billing_position_material] FOREIGN KEY ([material]) REFERENCES [dbo].[material] ([id]),
    CONSTRAINT [FK_billing_position_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]),
    CONSTRAINT [FK_billing_position_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]),
    CONSTRAINT [FK_billing_position_service] FOREIGN KEY ([service]) REFERENCES [dbo].[service] ([id])
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_position_update
   ON  dbo.billing_position 
   INSTEAD OF UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

END

GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER billing_position_audit
   ON  dbo.billing_position
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
