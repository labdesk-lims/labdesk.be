-- =============================================
-- Create date: 2024 October
-- Description:	Duplicate template
-- =============================================
CREATE PROCEDURE [dbo].[template_duplicate]
	@pTemplate As INT
AS
BEGIN
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	INSERT INTO template (customer, title, description, priority, workflow, report_template, deactivate) OUTPUT inserted.id INTO @id_keys VALUES((SELECT customer FROM template WHERE id = @pTemplate), (SELECT title FROM template WHERE id = @pTemplate) + '_duplicate', (SELECT description FROM template WHERE id = @pTemplate), (SELECT priority FROM template WHERE id = @pTemplate), (SELECT workflow FROM template WHERE id = @pTemplate), (SELECT report_template FROM template WHERE id = @pTemplate), (SELECT deactivate FROM template WHERE id = @pTemplate))

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	INSERT INTO template_profile (template, profile, priority, workflow, smppoint) (SELECT @id, profile, priority,workflow, smppoint FROM template_profile WHERE template = @pTemplate)
END