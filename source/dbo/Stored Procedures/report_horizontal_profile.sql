-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 September
-- Description:	Horizontal profile table
-- =============================================
CREATE PROCEDURE [dbo].[report_horizontal_profile]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE analysis_cur CURSOR FOR SELECT DISTINCT profile_analysis.analysis, analysis.sortkey FROM profile_analysis INNER JOIN profile ON (profile.id = profile_analysis.profile) INNER JOIN analysis ON (analysis.id = profile_analysis.analysis) WHERE profile_analysis.applies = 1 AND profile.id IN (SELECT profile FROM request WHERE subrequest = @request) ORDER BY analysis.sortkey
	DECLARE profile_cur CURSOR FOR SELECT request.profile FROM request WHERE subrequest = @request
	DECLARE @q1 NVARCHAR(MAX)
	DECLARE @q2 NVARCHAR(MAX)
	DECLARE @q3 NVARCHAR(MAX)
	DECLARE @q4 NVARCHAR(MAX)
	DECLARE @q5 NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @d INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @p NVARCHAR(MAX)
	DECLARE @a1 NVARCHAR(MAX)
	DECLARE @a2 NVARCHAR(MAX)
	DECLARE @min float
	DECLARE @max float
	DECLARE @min_inc float
	DECLARE @max_inc float
	DECLARE @language VARCHAR(32)

	-- Get the language setting for acutal user
	SET @language = (SELECT language FROM users WHERE name = ORIGINAL_LOGIN())

	-- Create horizontal table for measurement values
	SET @q1 = 'CREATE TABLE ##t (# NVARCHAR(MAX),'
	
	-- Build the query to create the table
	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @q1 = @q1 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ' NVARCHAR(MAX),'
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q1 = LEFT(@q1, LEN(@q1)-1) + ')'
	CLOSE analysis_cur
	
	-- Create table by executing query
	EXEC (@q1)

	-- Build the query to insert the analysis services
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'caption_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT TOP 1 analysis.title FROM analysis INNER JOIN method_analysis ON (method_analysis.analysis = analysis.id) INNER JOIN method ON (method.id = method_analysis.method) WHERE method_analysis.applies = 1 AND analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur

	-- Execute query to insert the analysis services
	EXEC (@q2 + @q3)
	
	-- Create an insert query for units
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'unit_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i, @d
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT analysis.unit FROM analysis INNER JOIN method_analysis ON (method_analysis.analysis = analysis.id) INNER JOIN method ON (method.id = method_analysis.method) WHERE method_analysis.applies = 1 AND analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i, @d
		END
	SET @q2 = LEFT(@q2, LEN(@q2)-1) + ') VALUES'
	SET @q3 = LEFT(@q3, LEN(@q3)-1) + ')'
	CLOSE analysis_cur
	
	-- Insert values
	EXEC (@q2 + @q3)

	-- Create an insert query for measurement values
	SET @s = ''
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + @s + '''' + ','

	OPEN profile_cur
	FETCH NEXT FROM profile_cur INTO @j
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Create an insert query for inserting values
			SET @p = (SELECT profile.title FROM profile WHERE profile.id = @j)
			SET @q4 = 'INSERT INTO ##t (#,'
			SET @q5 = '(' + '''' + @p + '''' + ','

			OPEN analysis_cur
			FETCH NEXT FROM analysis_cur INTO @i, @d
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @min = (SELECT profile_analysis.lsl FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @max = (SELECT profile_analysis.usl FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @min_inc = (SELECT profile_analysis.lsl_include FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)
					SET @max_inc = (SELECT profile_analysis.usl_include FROM profile_analysis WHERE profile_analysis.analysis = @i AND profile_analysis.profile = @j)

					IF (SELECT COUNT(*) FROM analysis WHERE analysis.type ='A' AND analysis.id = @i) > 0
					BEGIN
						SET @a1 = (SELECT attribute.title FROM attribute WHERE attribute.analysis = @i AND attribute.value = @min)
						SET @a2 = (SELECT attribute.title FROM attribute WHERE attribute.analysis = @i AND attribute.value = @max)
						SET @p = IIF(@min = @max, @a1, IIF(@min IS NULL, '', IIF(@min_inc = 1, '>=', '>') + @s) + IIF(@min IS NULL OR @max IS NULL, '', ' ... ') + IIF(@max IS NULL, '', IIF(@max_inc = 1, '<=', '<') + @s))
						SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
						SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					END
					IF (SELECT COUNT(*) FROM analysis WHERE analysis.type ='A' AND analysis.id = @i) = 0
					BEGIN
						SET @p = IIF(@min = @max, CONVERT(VARCHAR(MAX), @min), IIF(@min IS NULL, '', IIF(@min_inc = 1, '>=', '>') + CONVERT(VARCHAR(MAX), @min)) + IIF(@min IS NULL OR @max IS NULL, '', ' ... ') + IIF(@max IS NULL, '', IIF(@max_inc = 1, '<=', '<') + CONVERT(VARCHAR(MAX), @max)))
						SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
						SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					END
					FETCH NEXT FROM analysis_cur INTO @i, @d
				END
			SET @q4 = LEFT(@q4, LEN(@q4)-1) + ') VALUES'
			SET @q5 = LEFT(@q5, LEN(@q5)-1) + ')'

			-- Insert values
			EXEC (@q4 + @q5)
			CLOSE analysis_cur
			

			FETCH NEXT FROM profile_cur INTO @j
		END
	CLOSE profile_cur

	-- Return table
	SELECT * FROM ##t

	-- Cleanup tables and cursors
	DROP TABLE ##t
	DEALLOCATE analysis_cur
	DEALLOCATE profile_cur
END
