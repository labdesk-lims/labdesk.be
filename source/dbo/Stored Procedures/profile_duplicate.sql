-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 November
-- Description:	Duplicate profile
-- =============================================
CREATE PROCEDURE profile_duplicate
	-- Add the parameters for the stored procedure here
	@pProfile As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	INSERT INTO profile (title, description, use_profile_qc, reference_material, report_template, customer, price, deactivate) OUTPUT inserted.id INTO @id_keys VALUES((SELECT title FROM profile WHERE id = @pProfile) + '_duplicate', (SELECT description FROM profile WHERE id = @pProfile), (SELECT use_profile_qc FROM profile WHERE id = @pProfile), (SELECT reference_material FROM profile WHERE id = @pProfile), 
	
	(SELECT report_template FROM profile WHERE id = @pProfile), (SELECT customer FROM profile WHERE id = @pProfile), (SELECT price FROM profile WHERE id = @pProfile), 1)

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	INSERT INTO profile_analysis (profile, analysis, method, sortkey, applies, true_value, acceptance, tsl, lsl, lsl_include, usl, usl_include) (SELECT @id, analysis, method, sortkey, applies, true_value, acceptance, tsl, lsl, lsl_include, usl, usl_include FROM profile_analysis WHERE profile = @pProfile)
END