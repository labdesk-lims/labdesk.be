-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Create audit trail from record
-- =============================================
CREATE PROCEDURE [dbo].[template_run]
	-- Add the parameters for the stored procedure here
	@template INT,
	@priority INT,
	@workflow INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id INT = NULL
	DECLARE @i INT

	INSERT INTO request (description, customer, priority, workflow) VALUES ((SELECT '[' + SUSER_NAME() + '] ' + convert(nvarchar(max), (SELECT SYSDATETIME()))), (SELECT customer FROM template WHERE id = @template), @priority, @workflow)

	SET @id = SCOPE_IDENTITY()

	UPDATE request SET subrequest = NULL WHERE id = @id

	BEGIN
		DECLARE tmpl CURSOR FOR SELECT template_profile.id FROM template INNER JOIN template_profile ON (template.id = template_profile.template) WHERE template.id = (@template)

		OPEN tmpl
		FETCH NEXT FROM tmpl INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO request (customer, priority, profile, workflow, smppoint) SELECT customer, template_profile.priority, template_profile.profile, template_profile.workflow, template_profile.smppoint FROM template INNER JOIN template_profile ON (template.id = template_profile.template) WHERE template_profile.id = @i
			UPDATE request SET subrequest = @id WHERE id = SCOPE_IDENTITY()
			FETCH NEXT FROM tmpl INTO @i
		END
		CLOSE tmpl
		DEALLOCATE tmpl
	END
END
