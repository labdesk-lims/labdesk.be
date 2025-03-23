CREATE TABLE [dbo].[task] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [title]            VARCHAR (255)  NULL,
    [description]      NVARCHAR (MAX) NULL,
    [created_by]       VARCHAR (255)  CONSTRAINT [DF_task_created_by] DEFAULT (suser_name()) NULL,
    [created_at]       DATETIME       CONSTRAINT [DF_task_created_at] DEFAULT (getdate()) NULL,
    [responsible]      INT            NULL,
    [planned_start]    DATETIME       NULL,
    [planned_end]      DATETIME       NULL,
    [workload_planned] FLOAT (53)     NULL,
    [realized_start]   DATETIME       NULL,
    [realized_end]     DATETIME       NULL,
    [fulfillment]      INT            CONSTRAINT [DF_task_fullfillment] DEFAULT ((0)) NULL,
	[predecessor]	   INT            NULL,
    [project]          INT            NULL,
    [deactivate]       BIT            CONSTRAINT [DF_task_deactivate] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_task] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [PK_task_predecessor] FOREIGN KEY ([id]) REFERENCES [dbo].[task] ([id]),
    CONSTRAINT [FK_task_project] FOREIGN KEY ([project]) REFERENCES [dbo].[project] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_task_users] FOREIGN KEY ([responsible]) REFERENCES [dbo].[users] ([id])
);

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2025 February
-- Description:	Check plausibility of predecessor
-- =============================================
CREATE TRIGGER task_insert_update
   ON  dbo.task
   AFTER INSERT, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	-- Check if profile selection is valid
	IF (SELECT id FROM task WHERE project = (SELECT project FROM inserted) AND id = (SELECT predecessor FROM inserted)) IS NULL AND (SELECT predecessor FROM inserted) IS NOT NULL
		THROW 51000, 'Task not part of the project.', 1
END

GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER task_audit
   ON  dbo.task
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
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
