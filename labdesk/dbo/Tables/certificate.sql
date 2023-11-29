CREATE TABLE [dbo].[certificate] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [title]         VARCHAR (255)  NULL,
    [description]   NVARCHAR (MAX) NULL,
    [creation_date] DATETIME       NULL,
    [valid_from]    DATETIME       NOT NULL,
    [valid_till]    DATETIME       NOT NULL,
    [performed_by]  INT            NULL,
    [reviewed_by]   INT            NULL,
    [withdraw]      BIT            CONSTRAINT [DF_instrument_certificate_withdraw] DEFAULT ((0)) NOT NULL,
    [instrument]    INT            NOT NULL,
    CONSTRAINT [PK_instrument_certificate] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_instrument_certificate_contact] FOREIGN KEY ([performed_by]) REFERENCES [dbo].[contact] ([id]),
    CONSTRAINT [FK_instrument_certificate_contact1] FOREIGN KEY ([reviewed_by]) REFERENCES [dbo].[contact] ([id]),
    CONSTRAINT [FK_instrument_certificate_instrument] FOREIGN KEY ([instrument]) REFERENCES [dbo].[instrument] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[certificate_audit]
   ON  [dbo].[certificate]
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

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[certificate_insert_update] 
   ON  dbo.certificate
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )
	BEGIN
		IF (SELECT valid_from FROM inserted) > (SELECT valid_till FROM inserted) OR (SELECT creation_date FROM inserted) > (SELECT valid_from FROM inserted)
			THROW 51000, 'Wrong certificate dates.', 1
	END
END
