-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[calculation_extract_keyword]
	-- Add the parameters for the stored procedure here
	@equation NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @key_open BigIntList, @key_close BigIntList, @keys StringList, @pos INT, @i INT

	-- Store the position of opening brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX('[', @equation, @pos) > 0
	BEGIN
		INSERT INTO @key_open VALUES(@i, CHARINDEX('[', @equation, @pos))
		SET @pos = (SELECT value FROM @key_open WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the position of closing brackets
	SET @i = 0
	SET @pos = 1
	WHILE CHARINDEX(']', @equation, @pos) > 0
	BEGIN
		INSERT INTO @key_close VALUES(@i, CHARINDEX(']', @equation, @pos))
		SET @pos = (SELECT value FROM @key_close WHERE id = @i) + 1
		SET @i = @i + 1
	END

	-- Store the fields named in brackets
	SET @i = 0
	WHILE @i < (SELECT COUNT(*) FROM @key_Open)
	BEGIN
		INSERT INTO @keys VALUES(@i, SUBSTRING(@equation, (SELECT value FROM @key_open WHERE id = @i), (SELECT value FROM @key_close WHERE id = @i) - (SELECT value FROM @key_open WHERE id = @i) + 1))
		SET @i = @i + 1
	END

	-- Delete field duplicates
	DELETE T FROM (SELECT *, DupRank = ROW_NUMBER() OVER (PARTITION BY value ORDER BY (SELECT NULL)) FROM @keys) AS T WHERE DupRank > 1 

	SELECT * FROM @keys
END
