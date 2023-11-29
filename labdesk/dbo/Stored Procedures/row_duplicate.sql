-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	Dublicate row
-- =============================================
CREATE PROCEDURE [dbo].[row_duplicate]
	-- Add the parameters for the stored procedure here
	@p_tablename NVARCHAR(256),
	@p_ignore ColumnList READONLY,
	@p_id INT,
	@p_identity INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure herew
	DECLARE @i NVARCHAR(256)
	DECLARE @t TABLE(id INT)
	DECLARE @clmn NVARCHAR(MAX)
	DECLARE @vlus NVARCHAR(MAX)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE copy_cur CURSOR FOR SELECT c.name from sys.columns c inner join sys.tables t on c.object_id = t.object_id where t.name = @p_tablename
	
	OPEN copy_cur
	FETCH NEXT FROM copy_cur INTO @i
	WHILE @@FETCH_STATUS = 0

	BEGIN
		IF @i <> (SELECT DISTINCT Column_Name As [Column] FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE Table_Name = 'manufacturer') AND @i NOT IN (SELECT clmn FROM @p_ignore)
		BEGIN
			IF @vlus IS NOT NULL
				SET @vlus = @vlus + ',' + '(' + 'SELECT ' + @i + ' FROM ' + @p_tablename + ' WHERE id = ' + CONVERT(varchar, @p_id) + ')'
			ELSE
				SET @vlus = '(' + 'SELECT ' + @i + ' FROM ' + @p_tablename + ' WHERE id = ' + CONVERT(varchar, @p_id) + ')'

			IF @clmn IS NOT NULL
				SET @clmn = @clmn + ',' + @i
			ELSE
				SET @clmn = @i
		END
		
		FETCH NEXT FROM copy_cur INTO @i
	END

	SELECT @sql = 'INSERT INTO ' + @p_tablename + '(' + @clmn + ') VALUES (' + @vlus + '); SELECT SCOPE_IDENTITY();'

	INSERT INTO @t (id) EXEC (@sql)

	SET @p_identity = (SELECT TOP 1 * from @t)

	CLOSE copy_cur
	DEALLOCATE copy_cur
END
