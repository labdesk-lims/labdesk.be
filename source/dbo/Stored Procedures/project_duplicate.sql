CREATE PROCEDURE [dbo].[project_duplicate]
	-- Add the parameters for the stored procedure here
	@pProject As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @item As INT
	DECLARE @i INT
	DECLARE cur CURSOR FOR SELECT id FROM attachment WHERE attachment.project = @pProject

	INSERT INTO project (title, description, profile, owner, customer) SELECT title + '_duplicate', description, profile, owner, customer FROM project WHERE id = @pProject
	
	SET @item = SCOPE_IDENTITY()

	ALTER TABLE task DISABLE TRIGGER task_insert_update
	INSERT INTO task (title, description, created_by, created_at, responsible, planned_end, planned_start, workload_planned, predecessor, project) (SELECT title, description, created_by, created_at, responsible, planned_end, planned_start, workload_planned, predecessor, @item FROM task WHERE task.project = @pProject)
	ALTER TABLE task ENABLE TRIGGER task_insert_update

	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO attachment (title, file_name, attach, blob, project) (SELECT title, file_name, attach, blob, @item FROM attachment WHERE attachment.id = @i)
		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur
END
