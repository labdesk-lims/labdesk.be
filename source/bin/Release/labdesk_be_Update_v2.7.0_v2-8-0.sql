/*
Bereitstellungsskript für v2-7-0

Dieser Code wurde von einem Tool generiert.
Änderungen an dieser Datei führen möglicherweise zu falschem Verhalten und gehen verloren, falls
der Code neu generiert wird.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "v2-7-0"
:setvar DefaultFilePrefix "v2-7-0"
:setvar DefaultDataPath "D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "D:\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Überprüfen Sie den SQLCMD-Modus, und deaktivieren Sie die Skriptausführung, wenn der SQLCMD-Modus nicht unterstützt wird.
Um das Skript nach dem Aktivieren des SQLCMD-Modus erneut zu aktivieren, führen Sie folgenden Befehl aus:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Der SQLCMD-Modus muss aktiviert sein, damit dieses Skript erfolgreich ausgeführt werden kann.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Prozedur "[dbo].[report_horizontal_profile]" wird geändert...';


GO
-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2024 September
-- Description:	Horizontal profile table
-- =============================================
ALTER PROCEDURE [dbo].[report_horizontal_profile]
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
			SET @s = (SELECT TOP 1 analysis.title FROM analysis WHERE analysis.id = @i)
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
			SET @s = (SELECT analysis.unit FROM analysis WHERE analysis.id = @i)
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
			SET @p = (SELECT profile.description FROM profile WHERE profile.id = @j)
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
GO
PRINT N'Prozedur "[dbo].[version_be]" wird geändert...';


GO
-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Used to identify the backend version
-- ==================================================
ALTER PROCEDURE [dbo].[version_be]
	-- Add the parameters for the stored procedure here
	@version_be nvarchar(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @version_be = 'v2.8.0'
END
GO
PRINT N'Update abgeschlossen.';


GO
