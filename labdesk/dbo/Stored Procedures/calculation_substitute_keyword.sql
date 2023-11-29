-- ===============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Substitute keywords in calculation
-- ===============================================
CREATE PROCEDURE [dbo].[calculation_substitute_keyword] 
	-- Add the parameters for the stored procedure here
	@keywords StringList READONLY,
	@values KeyValueList READONLY,
	@equation NVARCHAR(MAX),
	@return_message NVARCHAR(MAX) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @key NVARCHAR(MAX)
	DECLARE @value NVARCHAR(MAX)

	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @keywords)
	BEGIN
		SET @key = (SELECT value FROM @keywords WHERE id = @i)
		SET @value = (SELECT value FROM @values WHERE keyword = @key)
		IF CHARINDEX('.', @value) = 0
			SET @value = @value + '.0'
		SET @equation = REPLACE(@equation, @key, @value )
		SET @i = @i + 1
	END

	SET @return_message = @equation
END
