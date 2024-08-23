-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 December
-- Description:	Multi-Report table
-- =============================================
CREATE PROCEDURE [dbo].[report_multiple] 
	-- Add the parameters for the stored procedure here
	@profile as int,
	@smppoint as int,
	@top as int,
	@from as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @query AS NVARCHAR(MAX)
	DECLARE @i AS INT
	DECLARE @f AS INT

	-- Start to prepare sql string for temporary table of the multi-report
	SET @query = 'CREATE TABLE ##t (analysis_id int, technique_sortkey int, analysis_sortkey int, technique nvarchar(max), analysis nvarchar(max), method nvarchar(max), lsl nvarchar(max), usl nvarchar(max), unit nvarchar(max), '

	-- Cursor to to add all samples as columns
	DECLARE tbl_cur CURSOR FOR SELECT TOP (@top) request FROM measurement INNER JOIN request ON measurement.request = request.id WHERE request.smppoint = @smppoint AND request <= @from GROUP BY request
	OPEN tbl_cur
	FETCH NEXT FROM tbl_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @query = @query + 'SMP' + CONVERT(nvarchar(255), @i) + ' nvarchar(max), '
		FETCH NEXT FROM tbl_cur INTO @i
	END
	CLOSE tbl_cur
	DEALLOCATE tbl_cur
	SET @query = LEFT(@query, LEN(@query)-1) + ')'

	-- Execute sql statement to create table
	exec (@query)

	-- Insert all analysis services into the newly created table
	INSERT INTO ##t (analysis_id) SELECT analysis FROM measurement INNER JOIN request ON measurement.request = request.id WHERE request.smppoint = @smppoint GROUP BY analysis

	-- Start to fill the table with all relevant data
	DECLARE x_cur CURSOR FOR SELECT TOP (@top) request FROM measurement INNER JOIN request ON measurement.request = request.id WHERE request.smppoint = @smppoint AND request <= @from  GROUP BY request
	OPEN x_cur
	FETCH NEXT FROM x_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE y_cur CURSOR FOR SELECT analysis FROM measurement WHERE request = @i
		OPEN y_cur
		FETCH NEXT FROM y_cur INTO @f
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @query = 'UPDATE ##t SET SMP' + CONVERT(nvarchar(max), @i) + ' = (SELECT value_txt FROM measurement WHERE request = ' + CONVERT(nvarchar(max), @i) + ' AND analysis = ' + CONVERT(nvarchar(max), @f) + ' AND state = ''VD'')' + 
			', lsl = (SELECT lsl FROM profile_analysis WHERE profile = ' + CONVERT(nvarchar(max), IsNull(@profile, 0)) + ' AND analysis = ' + CONVERT(nvarchar(max), @f) + ' AND applies = 1)' +
			', usl = (SELECT usl FROM profile_analysis WHERE profile = ' + CONVERT(nvarchar(max), IsNull(@profile, 0)) + ' AND analysis = ' + CONVERT(nvarchar(max), @f) + ' AND applies = 1)' +
			', technique_sortkey = (SELECT technique.sortkey FROM technique INNER JOIN analysis ON analysis.technique = technique.id WHERE analysis.id = ' + CONVERT(nvarchar(max), @f) + ')' +
			', analysis_sortkey = (SELECT sortkey FROM analysis WHERE id = ' + CONVERT(nvarchar(max), @f) + ')' +
			', technique = (SELECT technique.title FROM technique INNER JOIN analysis ON analysis.technique = technique.id WHERE analysis.id = ' + CONVERT(nvarchar(max), @f) + ')' +
			', analysis = (SELECT title FROM analysis WHERE id = ' + CONVERT(nvarchar(max), @f) + ')' +
			', method = (SELECT TOP 1 method.title FROM measurement INNER JOIN method ON method.id = measurement.method WHERE analysis = ' + CONVERT(nvarchar(max), @f) + ' ORDER BY measurement.id DESC)' +
			', unit = (SELECT TOP 1 unit FROM measurement WHERE analysis = ' + CONVERT(nvarchar(max), @f) + ' ORDER BY measurement.id DESC)' +
			' WHERE analysis_id = ' + CONVERT(nvarchar(max), @f)
			PRINT (@query)
			EXEC (@query)
			FETCH NEXT FROM y_cur INTO @f
		END
		CLOSE y_cur
		DEALLOCATE y_cur

		FETCH NEXT FROM x_cur INTO @i
	END
	CLOSE x_cur
	DEALLOCATE x_cur
	
	-- Select all data pushed to table
	SELECT * FROM ##t

	-- Drop temporary table
	DROP TABLE ##t
END
