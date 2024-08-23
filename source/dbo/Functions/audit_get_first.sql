-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION audit_get_first 
(
	-- Add the parameters for the function here
	@table_name VARCHAR(255),
	@table_id INT
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @changed_at DATETIME

	-- Add the T-SQL statements to compute the return value here
	SET @changed_at = (SELECT TOP 1 changed_at FROM audit WHERE table_name = @table_name AND table_id = @table_id)

	-- Return the result of the function
	RETURN @changed_at

END
