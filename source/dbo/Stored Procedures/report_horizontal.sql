-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 September
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[report_horizontal]
	-- Add the parameters for the stored procedure here
	@request INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE analysis_cur CURSOR FOR SELECT analysis.id FROM analysis WHERE analysis.id IN (SELECT measurement.analysis FROM request INNER JOIN measurement ON (measurement.request = request.id) WHERE request = @request OR subrequest = @request) ORDER BY analysis.sortkey
	DECLARE request_cur CURSOR FOR SELECT request.id FROM request WHERE request.subrequest = @request
	DECLARE @q1 NVARCHAR(MAX)
	DECLARE @q2 NVARCHAR(MAX)
	DECLARE @q3 NVARCHAR(MAX)
	DECLARE @q4 NVARCHAR(MAX)
	DECLARE @q5 NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @p NVARCHAR(MAX)
	DECLARE @language VARCHAR(32)

	-- Get the language setting for acutal user
	SET @language = (SELECT language FROM users WHERE name = ORIGINAL_LOGIN())

	-- Create horizontal table for measurement values
	SET @q1 = 'CREATE TABLE ##t (# NVARCHAR(MAX),'
	
	-- Build the query to create the table
	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @q1 = @q1 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ' NVARCHAR(MAX),'
			FETCH NEXT FROM analysis_cur INTO @i
		END
	SET @q1 = LEFT(@q1, LEN(@q1)-1) + ')'
	CLOSE analysis_cur
	PRINT @q1
	-- Create table by executing query
	EXEC (@q1)

	-- Build the query to insert the analysis services
	SET @s = N'SELECT @s = ' + @language + ' FROM translation WHERE container = ' + '''' + 'analysis' + '''' + ' AND item = ' + '''' + 'caption_' + ''''
	EXEC sp_executesql @query = @s,  @params = N'@s NVARCHAR(MAX) OUTPUT', @s = @s output
	SET @q2 = 'INSERT INTO ##t (#,'
	SET @q3 = '(' + '''' + ISNULL(@s, '') + '''' + ','

	OPEN analysis_cur
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT TOP 1 analysis.title FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i
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
	FETCH NEXT FROM analysis_cur INTO @i
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT analysis.unit FROM analysis WHERE analysis.id = @i)
			SET @q2 = @q2 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
			SET @q3 = @q3 + '''' + ISNULL(@s,'') + '''' + ','
			FETCH NEXT FROM analysis_cur INTO @i
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

	OPEN request_cur
	FETCH NEXT FROM request_cur INTO @j
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			-- Create an insert query for inserting values
			SET @p = (SELECT smppoint.title FROM request INNER JOIN smppoint ON (smppoint.id = request.smppoint) WHERE request.id = @j)
			SET @q4 = 'INSERT INTO ##t (#,'
			SET @q5 = '(' + '''' + @p + '''' + ','

			OPEN analysis_cur
			FETCH NEXT FROM analysis_cur INTO @i
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @p = (
					SELECT dbo.measurement.value_txt + IIF(dbo.measurement.out_of_spec = '', '', ' *') 
					FROM dbo.measurement INNER JOIN
                         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.instrument ON dbo.measurement.instrument = dbo.instrument.id LEFT OUTER JOIN
                         dbo.technique ON dbo.analysis.technique = dbo.technique.id LEFT OUTER JOIN
                         dbo.method ON dbo.measurement.method = dbo.method.id LEFT OUTER JOIN
                             (SELECT        dbo.request.id, dbo.profile_analysis.analysis, dbo.profile_analysis.tsl, CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'lsl', dbo.audit_get_first('request', dbo.request.id))) AS lsl, 
                                                         CONVERT(float, dbo.audit_get_value('profile_analysis', dbo.profile_analysis.id, 'usl', dbo.audit_get_first('request', dbo.request.id))) AS usl
                               FROM            dbo.request INNER JOIN
                                                         dbo.profile ON dbo.request.profile = dbo.profile.id INNER JOIN
                                                         dbo.profile_analysis ON dbo.profile_analysis.profile = dbo.profile.id
                               WHERE        (dbo.profile_analysis.applies = 1)) AS t ON t.analysis = dbo.measurement.analysis AND dbo.measurement.request = t.id
					WHERE        (dbo.measurement.request = @j) AND (dbo.analysis.id = @i) AND state = 'VD'
					)
					SET @q4 = @q4 + 'ID' + CONVERT(VARCHAR(MAX), @i) + ','
					SET @q5 = @q5 + '''' + ISNULL(@p,'') + '''' + ','
					FETCH NEXT FROM analysis_cur INTO @i
				END
			SET @q4 = LEFT(@q4, LEN(@q4)-1) + ') VALUES'
			SET @q5 = LEFT(@q5, LEN(@q5)-1) + ')'

			-- Insert values
			EXEC (@q4 + @q5)
			CLOSE analysis_cur
			

			FETCH NEXT FROM request_cur INTO @j
		END
	CLOSE request_cur

	-- Return table
	SELECT * FROM ##t

	-- Cleanup tables and cursors
	DROP TABLE ##t
	DEALLOCATE analysis_cur
	DEALLOCATE request_cur
END