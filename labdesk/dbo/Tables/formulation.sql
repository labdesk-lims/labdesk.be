CREATE TABLE [dbo].[formulation] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [title]       VARCHAR (255)  NULL,
    [description] NVARCHAR (MAX) NULL,
    [instruction] NVARCHAR (MAX) NULL,
    [owner]       VARCHAR (255)  CONSTRAINT [DF_formulation_owner] DEFAULT (suser_name()) NOT NULL,
    [project]     INT            NULL,
    [deactivate]  BIT            CONSTRAINT [DF_formulation_deactivate] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_formulation] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_formulation_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER [dbo].[formulation_audit]
   ON  dbo.formulation
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
