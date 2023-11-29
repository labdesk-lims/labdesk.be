CREATE TABLE [dbo].[profile] (
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [title]              VARCHAR (255)  NULL,
    [description]        NVARCHAR (MAX) NULL,
    [use_profile_qc]     BIT            CONSTRAINT [DF_profile_use_profile_qc] DEFAULT ((0)) NOT NULL,
    [reference_material] INT            NULL,
    [report_template]    VARCHAR (255)  NULL,
    [customer]           INT            NULL,
    [price]              MONEY          CONSTRAINT [DF_profile_price] DEFAULT ((0)) NOT NULL,
    [deactivate]         BIT            CONSTRAINT [DF_profile_deactivate] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_profile] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_profile_customer] FOREIGN KEY ([customer]) REFERENCES [dbo].[customer] ([id]),
    CONSTRAINT [FK_profile_strposition] FOREIGN KEY ([reference_material]) REFERENCES [dbo].[strposition] ([id])
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[profile_audit]
   ON  dbo.profile
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
CREATE TRIGGER profile_insert_update
   ON  dbo.profile
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @id INT
	SET @id = (SELECT id FROM inserted)

	INSERT INTO profile_analysis (profile, analysis) SELECT @id, id FROM analysis WHERE id NOT IN (SELECT analysis FROM profile_analysis WHERE profile = @id) AND deactivate = 0
END
