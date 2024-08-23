-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- ==============================================
CREATE PROCEDURE [dbo].[calculation_test] 
	-- Add the parameters for the stored procedure here
	@analysis INT,
	@response_message FLOAT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @f KeyValueList
	DECLARE @t StringList
	DECLARE @equation NVARCHAR(MAX)
	DECLARE @i INT
	DECLARE @id INT
	DECLARE @s NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @result FLOAT
	DECLARE cur CURSOR FOR SELECT id FROM cvalidate WHERE analysis = @analysis ORDER BY id

	SET @equation = (SELECT calculation FROM analysis WHERE id = @analysis)

	-- Get key and value
	OPEN cur
	FETCH NEXT FROM cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT analysis_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT cfield_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[F'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value FROM cvalidate WHERE id = @i))
		END

		IF (SELECT cfield_id FROM cvalidate WHERE id = @i) IS NULL
		BEGIN
			SET @id = (SELECT analysis_id FROM cvalidate WHERE id = @i)
			INSERT INTO @f
				VALUES ('[A'+CAST(@id As NVARCHAR(MAX))+']', (SELECT value FROM cvalidate WHERE id = @i))
		END

		FETCH NEXT FROM cur INTO @i
	END
	CLOSE cur
	DEALLOCATE cur

	-- Extract keywors of equation
	INSERT INTO @t
	EXEC calculation_extract_keyword @equation

	-- Substitute keywords by value
	EXEC calculation_substitute_keyword @t, @f, @equation, @s OUT

	-- Evaluate euqation
	SET @sql = 'select @result = ' + @s
	EXEC sp_executesql @sql, N'@result float output', @result OUT

	-- Return value being calculated
	SET @response_message = @result
END