CREATE TABLE [dbo].[contact] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [salutation]          VARCHAR (255)   NULL,
    [first_name]          VARCHAR (255)   NULL,
    [last_name]           VARCHAR (255)   NULL,
    [job_title]           VARCHAR (255)   NULL,
    [signature]           VARBINARY (MAX) NULL,
    [photo]               VARBINARY (MAX) NULL,
    [email]               VARCHAR (255)   NULL,
    [phone]               VARCHAR (255)   NULL,
    [mobile]              VARCHAR (255)   NULL,
    [fax]                 VARCHAR (255)   NULL,
    [website]             VARCHAR (255)   NULL,
    [postal_country]      VARCHAR (255)   NULL,
    [postal_state]        VARCHAR (255)   NULL,
    [postal_district]     VARCHAR (255)   NULL,
    [postal_city]         VARCHAR (255)   NULL,
    [postal_postalcode]   VARCHAR (255)   NULL,
    [postal_street]       VARCHAR (255)   NULL,
    [postal_housenumber]  VARCHAR (255)   NULL,
    [billing_country]     VARCHAR (255)   NULL,
    [billing_state]       VARCHAR (255)   NULL,
    [billing_district]    VARCHAR (255)   NULL,
    [billing_city]        VARCHAR (255)   NULL,
    [billing_postalcode]  VARCHAR (255)   NULL,
    [billing_street]      VARCHAR (255)   NULL,
    [billing_housenumber] VARCHAR (255)   NULL,
    [bank]                VARCHAR (255)   NULL,
    [iban]                VARCHAR (255)   NULL,
    [bic]                 VARCHAR (255)   NULL,
    [vatnr]               VARCHAR (255)   NULL,
    [sampler]             BIT             CONSTRAINT [DF_contact_sampler] DEFAULT ((0)) NULL,
    [deactivate]          BIT             CONSTRAINT [DF_contact_deactivate] DEFAULT ((0)) NOT NULL,
    [customer]            INT             NULL,
    CONSTRAINT [PK_contact] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_contact_customer1] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[contact_audit]
   ON  dbo.contact
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
