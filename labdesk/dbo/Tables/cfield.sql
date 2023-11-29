CREATE TABLE [dbo].[cfield] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255) NULL,
    [unit]        VARCHAR (255) NULL,
    [analysis_id] INT           NULL,
    [analysis]    INT           NOT NULL,
    CONSTRAINT [PK_cfield] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_cfield_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[cfield_audit] 
   ON  [dbo].[cfield]
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
CREATE TRIGGER [dbo].[cfield_update_insert]
   ON  dbo.cfield
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @id INT

	SET @id = (SELECT analysis FROM inserted)

	IF (SELECT analysis_id FROM inserted) IS NOT NULL AND (SELECT analysis_id FROM inserted) NOT IN (SELECT id FROM analysis)
		THROW 51000, 'Analysis not found.', 1

	IF (SELECT analysis_id FROM inserted) IS NOT NULL
	BEGIN
		UPDATE cfield SET title = NULL WHERE id = (SELECT id FROM inserted)
		UPDATE cfield SET unit = NULL WHERE id = (SELECT id FROM inserted)
	END

	DELETE FROM cvalidate WHERE analysis = @id
	INSERT INTO cvalidate (cfield_id, analysis_id, analysis) SELECT id, null, @id FROM cfield WHERE analysis = @id AND analysis_id IS NULL
	INSERT INTO cvalidate (cfield_id, analysis_id, analysis) SELECT null, analysis_id, @id FROM cfield WHERE analysis = @id AND analysis_id IS NOT NULL
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[cfield_delete] 
   ON  [dbo].[cfield]
   AFTER DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF ( (SELECT trigger_nestlevel() ) < 2 )  
	BEGIN
		DELETE FROM cvalidate WHERE analysis = (SELECT id from deleted) AND cfield_id = (SELECT id FROM deleted) OR analysis_id = (SELECT analysis_id FROM deleted)
	END
END
