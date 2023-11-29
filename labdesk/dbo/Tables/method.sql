CREATE TABLE [dbo].[method] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [title]          VARCHAR (255)  NULL,
    [edition]        NVARCHAR (255) NULL,
    [description]    NVARCHAR (MAX) NULL,
    [price]          MONEY          CONSTRAINT [DF_method_price] DEFAULT ((0)) NOT NULL,
    [subcontraction] BIT            CONSTRAINT [DF_method_subcontraction] DEFAULT ((0)) NOT NULL,
    [deactivate]     BIT            CONSTRAINT [DF_method_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_method] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [CK_method] CHECK ([price]>=(0))
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[method_audit]
   ON  dbo.method
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
CREATE TRIGGER [dbo].[method_insert_update]
   ON  dbo.method
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM instrument_method WHERE applies = 1 AND method = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Method is still in use.', 1

	-- Update instrument_method and method_analysis cross table
	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO instrument_method (instrument, method) SELECT id, (SELECT id FROM inserted) FROM instrument WHERE id NOT IN (SELECT instrument FROM instrument_method WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
		INSERT INTO method_analysis (method, analysis) SELECT (SELECT id FROM inserted), id FROM analysis WHERE id NOT IN (SELECT analysis FROM method_analysis WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
	END
	
	-- Update method_smptype cross table
	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO method_smptype (method, smptype) SELECT (SELECT id FROM inserted), id FROM smptype WHERE id NOT IN (SELECT smptype FROM method_smptype WHERE method = (SELECT id FROM inserted)) AND deactivate = 0
	END
END
