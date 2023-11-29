-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 May
-- Description:	Get ID of SUSER_NAME
-- =============================================
CREATE FUNCTION [dbo].[users_get_id]
(
	-- Add the parameters for the function here
	@suser_name nvarchar(255)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @id INT

	-- Add the T-SQL statements to compute the return value here
	SET @id = (SELECT id FROM users WHERE name = @suser_name)

	-- Return the result of the function
	RETURN @id

END
