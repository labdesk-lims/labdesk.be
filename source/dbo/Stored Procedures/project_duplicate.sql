CREATE PROCEDURE [dbo].[project_duplicate]
	-- Add the parameters for the stored procedure here
	@pProject As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO project (title, description, profile, owner, customer) SELECT title + '_duplicate', description, profile, owner, customer FROM project WHERE id = @pProject

	ALTER TABLE task DISABLE TRIGGER task_insert_update
	INSERT INTO task (title, description, created_by, created_at, responsible, planned_end, planned_start, workload_planned, predecessor, project) (SELECT title, description, created_by, created_at, responsible, planned_end, planned_start, workload_planned, predecessor, SCOPE_IDENTITY() FROM task WHERE task.project = @pProject)
	ALTER TABLE task ENABLE TRIGGER task_insert_update
END
