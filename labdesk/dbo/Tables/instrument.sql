CREATE TABLE [dbo].[instrument] (
    [id]                INT             IDENTITY (1, 1) NOT NULL,
    [title]             VARCHAR (255)   NULL,
    [description]       NVARCHAR (MAX)  NULL,
    [asset_number]      VARCHAR (255)   NULL,
    [type]              INT             NULL,
    [manufacturer]      INT             NULL,
    [supplier]          INT             NULL,
    [model]             VARCHAR (255)   NULL,
    [serial_number]     VARCHAR (255)   NULL,
    [photo]             VARBINARY (MAX) NULL,
    [installation_date] DATETIME        NULL,
    [deactivate]        BIT             CONSTRAINT [DF_instrument_deactivate] DEFAULT ((0)) NOT NULL,
    [workplace]         INT             NULL,
    CONSTRAINT [PK_instrument] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_instrument_instrument_type] FOREIGN KEY ([type]) REFERENCES [dbo].[instype] ([id]),
    CONSTRAINT [FK_instrument_manufacturer] FOREIGN KEY ([manufacturer]) REFERENCES [dbo].[manufacturer] ([id]),
    CONSTRAINT [FK_instrument_supplier] FOREIGN KEY ([supplier]) REFERENCES [dbo].[supplier] ([id]),
    CONSTRAINT [FK_instrument_workplace] FOREIGN KEY ([workplace]) REFERENCES [dbo].[workplace] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[instrument_audit]
   ON  [dbo].[instrument] 
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
-- ==============================================
CREATE TRIGGER [dbo].[instrument_insert_update] 
   ON  dbo.instrument 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM instrument_method WHERE applies = 1 AND instrument = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Instrument is still in use.', 1
	
	-- Update instrument_method cross table
	IF NOT EXISTS (SELECT id FROM deleted)
		INSERT INTO instrument_method (instrument, method) SELECT (SELECT id FROM inserted), id FROM method WHERE id NOT IN (SELECT method FROM instrument_method WHERE instrument = (SELECT id FROM inserted)) AND deactivate = 0
END
