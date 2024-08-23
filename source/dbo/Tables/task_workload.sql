CREATE TABLE [dbo].[task_workload] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [workday]          DATETIME      NULL,
    [workload]         FLOAT (53)    NULL,
    [created_by]       VARCHAR (255) CONSTRAINT [DF_workload_created_by] DEFAULT (suser_name()) NULL,
    [created_at]       DATETIME      NULL,
    [task]             INT           NULL,
    [billing_customer] INT           NULL,
    CONSTRAINT [PK_workload] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_task_workload_billing_customer] FOREIGN KEY ([billing_customer]) REFERENCES [dbo].[billing_customer] ([id]) ON DELETE SET NULL,
    CONSTRAINT [FK_workload_task] FOREIGN KEY ([task]) REFERENCES [dbo].[task] ([id]) ON DELETE CASCADE
);


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- =============================================
CREATE TRIGGER workload_audit 
   ON  [dbo].[task_workload]
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
