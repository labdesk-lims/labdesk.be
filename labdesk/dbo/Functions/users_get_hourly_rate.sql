-- =============================================
-- Author:		Kogel, Lutz
-- Create date: November 2023
-- Description:	Get hourly rate of users
-- =============================================
CREATE FUNCTION users_get_hourly_rate
(
	-- Add the parameters for the function here
	@user_name VARCHAR(255)
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @rate money

	-- Add the T-SQL statements to compute the return value here
	SET @rate = (SELECT role.hourly_rate FROM role INNER JOIN users ON users.role = role.id WHERE name = @user_name)

	-- Return the result of the function
	RETURN @rate

END
