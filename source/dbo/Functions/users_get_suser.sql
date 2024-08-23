-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 May
-- Description:	Get SUSER_NAME from id
-- =============================================
CREATE FUNCTION users_get_suser
(
	-- Add the parameters for the function here
	@id int
)
RETURNS nvarchar(255)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @suser_name nvarchar(255)

	-- Add the T-SQL statements to compute the return value here
	SET @suser_name = (SELECT name FROM users WHERE id = @id)

	-- Return the result of the function
	RETURN @suser_name

END
