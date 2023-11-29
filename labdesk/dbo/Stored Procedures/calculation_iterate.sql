-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[calculation_iterate]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @f FLOAT
	DECLARE c_cur CURSOR FOR SELECT measurement.id FROM measurement INNER JOIN analysis ON (analysis.id = measurement.analysis) WHERE measurement.request = @request AND (measurement.state = 'CP' Or measurement.state = 'AQ' Or measurement.state = 'VD') AND analysis.calculation_activate = 1 ORDER BY measurement.id

	OPEN c_cur
	FETCH NEXT FROM c_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC calculation_perform @i, @f OUTPUT
		UPDATE measurement SET value_num = @f WHERE id = @i AND (state = 'AQ' Or state = 'CP')
		FETCH NEXT FROM c_cur INTO @i
	END
	CLOSE c_cur
	DEALLOCATE c_cur
END
