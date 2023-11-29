-- =======================================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Insert a measurement with conditions and calculated fields
-- =======================================================================
CREATE PROCEDURE [dbo].[measurement_insert]
	-- Add the parameters for the stored procedure here
	@request INT,
	@analysis INT,
	@method INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- DECLARE @method INT, @instrument INT
	DECLARE @unit VARCHAR(255)
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT

	 IF @method IS NULL
	 	SET @method = (SELECT TOP 1 method FROM method_analysis WHERE analysis = @analysis AND standard = 1 AND applies = 1)

	-- SET @method = (SELECT method FROM method_analysis WHERE analysis = @analysis AND standard = 1 AND applies = 1 AND method IN (SELECT method FROM qualification WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0))
	-- SET @instrument = (SELECT instrument FROM instrument_method WHERE method = @method AND standard = 1 AND applies = 1 AND instrument IN (SELECT instrument FROM certificate WHERE valid_from <= GETDATE() AND valid_till >= GETDATE() AND withdraw = 0))

	-- INSERT INTO measurement (request, analysis, method, instrument, state) OUTPUT inserted.id INTO @id_keys SELECT @request, @analysis, @method, @instrument, 'CP' WHERE @analysis NOT IN (SELECT @analysis FROM measurement WHERE request = @request AND analysis = @analysis AND (state = 'CP' OR state = 'AQ' OR state = 'VD')) 

	INSERT INTO measurement (request, analysis, method, state) OUTPUT inserted.id INTO @id_keys SELECT @request, @analysis, @method, 'CP' WHERE @analysis NOT IN (SELECT @analysis FROM measurement WHERE request = @request AND analysis = @analysis AND (state = 'CP' OR state = 'AQ' OR state = 'VD')) 
	
	SET @id = (SELECT TOP 1 id FROM @id_keys)

	-- Set unit
	UPDATE measurement SET unit = (SELECT unit FROM analysis WHERE id = (SELECT analysis FROM measurement WHERE id = @id)) WHERE id = @id

	-- Set subcontraction
	IF @method IS NOT NULL UPDATE measurement SET subcontraction = (SELECT subcontraction FROM method WHERE id = @method) WHERE id = @id

	IF (SELECT condition_activate FROM analysis WHERE id = @analysis) = 1
	BEGIN
		-- Insert analysis specific conditions
		INSERT INTO measurement_condition (condition, measurement) SELECT id, @id FROM condition WHERE analysis = (SELECT analysis FROM measurement WHERE id = @id)
	END

	IF (SELECT calculation_activate FROM analysis WHERE id = @analysis) = 1
	BEGIN
		-- Insert analysis specific cfield
		INSERT INTO measurement_cfield (cfield, measurement) SELECT id, @id FROM cfield WHERE analysis = (SELECT analysis FROM measurement WHERE id = @id) AND analysis_id IS NULL
	END
END
