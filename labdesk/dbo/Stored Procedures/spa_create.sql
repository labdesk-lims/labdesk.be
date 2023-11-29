-- ================================================
-- Author:		Kogel, Lutz
-- Create date: 2022-03-10
-- Description:	Peform Statistical Process Analysis
-- ================================================
CREATE PROCEDURE [dbo].[spa_create] 
	-- Add the parameters for the stored procedure here
	@uid NVARCHAR(256),
	@profile INT,
	@analysis INT,
	@from DATETIME,
	@till DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @usl FLOAT
	DECLARE @lsl FLOAT

	-- Set limits
	SET @usl = (SELECT usl FROM profile_analysis WHERE profile = @profile AND analysis = @analysis)
	SET @lsl = (SELECT lsl FROM profile_analysis WHERE profile = @profile AND analysis = @analysis)

	-- Delete old values
	DELETE FROM spa WHERE uid = @uid

	-- Insert measurement values
	INSERT INTO spa (uid, value, validated_at) SELECT @uid, measurement.value_num, measurement.validated_at FROM measurement INNER JOIN request ON (measurement.request = request.id) WHERE request.profile = @profile AND measurement.analysis = @analysis AND measurement.validated_at >= @from AND measurement.validated_at <= @till

	-- Set outlier values
	DECLARE @sql NVARCHAR(max)
	DECLARE @o INT
	DECLARE @i INT
	DECLARE @t table (id int)
	SET @o = (SELECT COUNT(*) FROM spa WHERE uid = @uid) * 0.5
	SET @sql = 'SELECT id, value FROM spa WHERE uid = ''' + @uid + ''''
	INSERT INTO @t EXEC gesd_test @sql, 0.05, @o
	DECLARE gesd_cursor CURSOR FOR SELECT id FROM @t
	OPEN gesd_cursor
	FETCH NEXT FROM gesd_cursor INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE spa SET outlier = (SELECT value FROM spa WHERE id = @i) WHERE id = @i
		FETCH NEXT FROM gesd_cursor INTO @i
	END
	CLOSE gesd_cursor
	DEALLOCATE gesd_cursor

	-- Unpdate measurement values minus outliers
	UPDATE spa SET value_minus_outlier = value FROM spa WHERE outlier IS NULL

	-- Set average
	UPDATE spa SET average = (SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) WHERE uid = @uid

	-- Set standard deviation
	UPDATE spa SET stdev = (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid) WHERE uid = @uid

	-- Set action limit
	UPDATE spa SET ual = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) +  3 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid
	UPDATE spa SET lal = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) -  3 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid

	-- Set warning limit
	UPDATE spa SET uwl = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) +  2 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid
	UPDATE spa SET lwl = ((SELECT AVG(value_minus_outlier) FROM spa WHERE uid = @uid) -  2 * (SELECT STDEV(value_minus_outlier) FROM spa WHERE uid = @uid)) WHERE uid = @uid

	-- Set time series
	UPDATE spa SET time = id - (SELECT MIN(id) FROM spa WHERE uid = @uid) + 1 WHERE uid = @uid

	-- Set usl and lsl
	UPDATE spa SET usl = @usl WHERE uid = @uid
	UPDATE spa SET lsl = @lsl WHERE uid = @uid
END
