CREATE TABLE [dbo].[laboratory] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [title]               VARCHAR (255)   NULL,
    [manager]             INT             NULL,
    [vatnr]               VARCHAR (255)   NULL,
    [fax]                 VARCHAR (255)   NULL,
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
    [lab_url]             VARCHAR (2048)  NULL,
    [lab_logo]            VARBINARY (MAX) NULL,
    [account_type]        VARCHAR (255)   NULL,
    [account_iban]        VARCHAR (255)   NULL,
    [account_bic]         VARCHAR (255)   NULL,
    [account_bank]        VARCHAR (255)   NULL,
    [account_branch]      VARCHAR (255)   NULL,
    [accredited]          BIT             CONSTRAINT [DF_laboratory_accredited] DEFAULT ((0)) NULL,
    [accreditation]       VARCHAR (255)   NULL,
    [acc_uid]             VARCHAR (255)   NULL,
    [acc_body]            VARCHAR (255)   NULL,
    [acc_url]             VARCHAR (2048)  NULL,
    [acc_logo]            VARBINARY (MAX) NULL,
    [acc_letterhead]      NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_laboratory] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_laboratory_contact] FOREIGN KEY ([manager]) REFERENCES [dbo].[contact] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[laboratory_insert] 
   ON  dbo.laboratory
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT COUNT(id) FROM laboratory) > 1
		THROW 51000, 'Only one row laboratory is allowed.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[laboratory_audit]
   ON  [dbo].[laboratory]
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
