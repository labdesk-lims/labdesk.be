CREATE TABLE [dbo].[customer] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [name]                VARCHAR (255)  NULL,
    [homepage]            NVARCHAR (MAX) NULL,
    [postal_country]      VARCHAR (255)  NULL,
    [postal_state]        VARCHAR (255)  NULL,
    [postal_district]     VARCHAR (255)  NULL,
    [postal_city]         VARCHAR (255)  NULL,
    [postal_postalcode]   VARCHAR (255)  NULL,
    [postal_street]       VARCHAR (255)  NULL,
    [postal_housenumber]  VARCHAR (255)  NULL,
    [billing_country]     VARCHAR (255)  NULL,
    [billing_state]       VARCHAR (255)  NULL,
    [billing_district]    VARCHAR (255)  NULL,
    [billing_city]        VARCHAR (255)  NULL,
    [billing_postalcode]  VARCHAR (255)  NULL,
    [billing_street]      VARCHAR (255)  NULL,
    [billing_housenumber] VARCHAR (255)  NULL,
    [bank]                VARCHAR (255)  NULL,
    [iban]                VARCHAR (255)  NULL,
    [bic]                 VARCHAR (255)  NULL,
    [vatnr]               VARCHAR (255)  NULL,
    [discount]            FLOAT (53)     CONSTRAINT [DF_customer_discount] DEFAULT ((0)) NOT NULL,
    [deactivate]          BIT            CONSTRAINT [DF_customer_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_customer] CHECK ([discount]>=(0) AND [discount]<=(100))
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[customer_audit]
   ON  dbo.customer
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
