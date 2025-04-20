CREATE TABLE [dbo].[analysis] (
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [title]                VARCHAR (255)  NULL,
    [technique]            INT            NULL,
    [description]          NVARCHAR (MAX) NULL,
    [unit]                 VARCHAR (255)  NULL,
    [type]                 CHAR (1)       CONSTRAINT [DF_analysis_type] DEFAULT ('N') NOT NULL,
    [precision]            INT            CONSTRAINT [DF_analysis_precision] DEFAULT ((0)) NOT NULL,
    [ldl]                  FLOAT (53)     NULL,
    [udl]                  FLOAT (53)     NULL,
    [calculation]          NVARCHAR (MAX) NULL,
    [calculation_activate] BIT            CONSTRAINT [DF_analysis_calculation_activate] DEFAULT ((0)) NOT NULL,
    [condition_activate]   BIT            CONSTRAINT [DF_analysis_condition_activate] DEFAULT ((0)) NOT NULL,
    [uncertainty_activate] BIT            CONSTRAINT [DF_analysis_uncertainty_activate] DEFAULT ((0)) NOT NULL,
    [sortkey]              INT            NULL,
    [deactivate]           BIT            CONSTRAINT [DF_analysis_deactivate] DEFAULT ((0)) NOT NULL,
    [price]                MONEY          CONSTRAINT [DF_analysis_price] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_analysis] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_analysis_technique] FOREIGN KEY ([technique]) REFERENCES [dbo].[technique] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[analysis_audit] 
   ON  dbo.analysis
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
CREATE TRIGGER [dbo].[analysis_insert_update]
   ON  dbo.analysis
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT deactivate FROM inserted) = 1 AND (SELECT COUNT(id) FROM method_analysis WHERE applies = 1 AND analysis = (SELECT (id) FROM inserted)) > 0
		THROW 51000, 'Deactivation failed. Analysis is still in use.', 1

	-- Update instrument_method and method_analysis cross table
	DECLARE @id INT

	SET @id = (SELECT id FROM inserted)

	IF NOT EXISTS (SELECT id FROM deleted)
	BEGIN
		INSERT INTO method_analysis (method, analysis) SELECT id, @id FROM method WHERE id NOT IN (SELECT method FROM method_analysis WHERE analysis = @id) AND deactivate = 0
		IF (SELECT COUNT(id) FROM PROFILE) > 0
		BEGIN
			INSERT INTO profile_analysis (profile, analysis) SELECT DISTINCT profile.id, @id FROM analysis LEFT JOIN profile ON (profile.id <> 0)
		END
	END

	IF (SELECT calculation_activate FROM inserted) = 1 AND (SELECT calculation FROM inserted) IS NULL
		THROW 51000, 'Activation failed. Calculation not found.', 1

	IF (SELECT ldl FROM inserted) > (SELECT udl FROM inserted)
		THROW 51000,  'LDL bigger than UDL.', 1

	IF (SELECT precision FROM inserted) < 0
		THROW 51000,  'Precision must be zero or bigger.', 1

	IF (SELECT type FROM inserted) <> 'N' AND (SELECT type FROM inserted) <> 'A' AND (SELECT type FROM inserted) <> 'T'
		THROW 51000,  'Type unknown.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE TRIGGER [dbo].[analysis_delete] 
   ON  dbo.analysis 
   INSTEAD OF DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @err_msg NVARCHAR(MAX)

	IF (SELECT COUNT(*) FROM cfield WHERE analysis_id = (SELECT id FROM deleted)) > 0 OR (SELECT COUNT(*) FROM profile_analysis WHERE analysis = (SELECT id FROM deleted) AND applies = 1) > 0
		THROW 51000, 'Can not delete. Analysis used in cfield or profile.', 1
	ELSE
		DELETE FROM analysis WHERE id = (SELECT id FROM deleted)
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N-Numeric, A-Attribute, T-Text', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'analysis', @level2type = N'COLUMN', @level2name = N'type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'R-Range,C-Calculation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'analysis', @level2type = N'COLUMN', @level2name = N'uncertainty_activate';

