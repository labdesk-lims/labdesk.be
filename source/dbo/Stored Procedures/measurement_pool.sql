-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022-07-27
-- Description:	Pool all measurements in batch
-- =============================================
CREATE PROCEDURE [dbo].[measurement_pool] 
	-- Add the parameters for the stored procedure here
	@p_id INT -- ID of the measurment to pool in batch
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @batch INT
	DECLARE @analysis INT
	DECLARE @i INT
	DECLARE @method INT, @instrument INT, @value_num INT, @value_txt INT, @state CHAR(2)

	SET @batch = (SELECT batch FROM btcposition WHERE request = (SELECT request FROM measurement WHERE id = @p_id))
	SET @analysis = (SELECT analysis FROM measurement WHERE id = @p_id)
	SET @method = (SELECT method FROM measurement WHERE id = @p_id)
	SET @instrument = (SELECT instrument FROM measurement WHERE id = @p_id)
	SET @value_num = (SELECT value_num FROM measurement WHERE id = @p_id)
	SET @value_txt = (SELECT value_txt FROM measurement WHERE id = @p_id)
	SET @state = (SELECT state FROM measurement WHERE id = @p_id)

	DECLARE msmt_cur CURSOR FOR SELECT measurement.id FROM measurement INNER JOIN request ON (measurement.request = request.id) INNER JOIN btcposition ON (request.id = btcposition.request) WHERE btcposition.batch = @batch AND measurement.analysis = @analysis ORDER BY measurement.id

	OPEN msmt_cur
	FETCH NEXT FROM msmt_cur INTO @i
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Update the measurements in the pool based on values of @p_id
			UPDATE measurement SET value_txt = @value_txt, value_num = @value_num, method = @method, instrument = @instrument, state = @state WHERE id = @i AND state = 'CP'
			FETCH NEXT FROM msmt_cur INTO @i
		END
	CLOSE msmt_cur
	DEALLOCATE msmt_cur
END
