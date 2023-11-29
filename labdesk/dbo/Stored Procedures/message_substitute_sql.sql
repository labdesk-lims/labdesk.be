-- =======================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Substitute SQL statements in message texts
-- =======================================================
CREATE PROCEDURE [dbo].[message_substitute_sql]
	-- Add the parameters for the stored procedure here
	@p_message NVARCHAR(MAX),
	@return_message NVARCHAR(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @t StringList
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @tmp NVARCHAR(MAX)
	DECLARE @value NVARCHAR(MAX)

	-- Create list with sql statements to execute
	INSERT INTO @t EXEC message_extract_sql @p_message

	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @t)
	BEGIN
		-- Get the sql statement with paranthesis for substitiution
		SET @sql = (SELECT value FROM @t WHERE id = @i)

		-- Exclude parantheses for execution
		SET @tmp = REPLACE(REPLACE(@sql, ']', ''), '[', '')

		-- Prevent data from being manipulated
		IF CHARINDEX('INSERT', @tmp) <> 0 OR CHARINDEX('UPDATE', @tmp) <> 0 OR CHARINDEX('DELETE', @tmp) <> 0 
			THROW 51000, 'Forbidden statement.', 1

		-- Execute sql statement
		EXEC sp_executesql @tmp, N'@value nvarchar(max) output', @value OUT

		-- Substitute sql statement with value
		SET @p_message = REPLACE(@p_message, @sql, @value)

		SET @i = @i + 1
	END

	SET @return_message = @p_message
END
