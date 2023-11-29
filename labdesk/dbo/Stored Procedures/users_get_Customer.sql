-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	Get customer id from user
-- =============================================
CREATE PROCEDURE users_get_Customer 
	-- Add the parameters for the stored procedure here
	@response_message INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @response_message = (SELECT customer.id FROM customer INNER JOIN contact ON (customer.id = contact.customer) WHERE contact.id = (SELECT contact FROM users WHERE name = SUSER_NAME()))
END
