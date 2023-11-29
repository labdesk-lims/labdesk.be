CREATE TABLE [dbo].[profile_analysis] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [profile]     INT           NOT NULL,
    [analysis]    INT           NOT NULL,
    [method]      INT           NULL,
    [sortkey]     INT           NULL,
    [applies]     BIT           CONSTRAINT [DF_profile_analysis_applies] DEFAULT ((0)) NOT NULL,
    [true_value]  FLOAT (53)    NULL,
    [acceptance]  FLOAT (53)    NULL,
    [tsl]         VARCHAR (255) NULL,
    [lsl]         FLOAT (53)    NULL,
    [lsl_include] BIT           CONSTRAINT [DF_profile_analysis_lsl_include] DEFAULT ((0)) NOT NULL,
    [usl]         FLOAT (53)    NULL,
    [usl_include] BIT           CONSTRAINT [DF_profile_analysis_usl_include] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_profile_analysis] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_profile_analysis_analysis] FOREIGN KEY ([analysis]) REFERENCES [dbo].[analysis] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_profile_analysis_method] FOREIGN KEY ([method]) REFERENCES [dbo].[method] ([id]),
    CONSTRAINT [FK_profile_analysis_profile] FOREIGN KEY ([profile]) REFERENCES [dbo].[profile] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[profile_analysis_audit]
   ON  dbo.profile_analysis
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
CREATE TRIGGER [dbo].[profile_analysis_update] 
   ON  dbo.profile_analysis
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF (SELECT applies FROM inserted) = 1
		UPDATE profile_analysis SET applies = 1 WHERE analysis IN (SELECT analysis_ID FROM cfield WHERE analysis = (SELECT analysis FROM inserted) AND analysis_id IS NOT NULL)

	IF (SELECT lsl FROM inserted) > (SELECT usl FROM inserted)
		THROW 51000, 'LSL bigger than USL.', 1
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Text specification limit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'profile_analysis', @level2type = N'COLUMN', @level2name = N'tsl';

