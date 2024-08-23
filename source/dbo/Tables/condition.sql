CREATE TABLE [dbo].[condition] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [type]        CHAR (1)       CONSTRAINT [DF_condition_type] DEFAULT ('N') NOT NULL,
    [attributes]  NVARCHAR (MAX) NULL,
    [analysis]    INT            NOT NULL,
    CONSTRAINT [PK_condition] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_condition_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[condition_insert_update] 
   ON  dbo.condition 
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @type CHAR(1)
	
	SET @type = (SELECT type FROM inserted)

	IF @type != 'N' and @type != 'A' and @type != 'T'
		THROW 51000, 'Type non valid. Choose N-Numeric, A-Attributive or S-String.', 1

	IF @type = 'A' and (SELECT attributes FROM inserted) IS NULL
		THROW 51000, 'Attributes missing.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[condition_audit] 
   ON  [dbo].[condition]
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'N-Numeric, A-Attribute, T-Text', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'condition', @level2type = N'COLUMN', @level2name = N'type';

