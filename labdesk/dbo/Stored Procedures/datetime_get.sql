-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2023 October
-- Description:	Get SystemDateTime
-- =============================================
CREATE PROCEDURE [dbo].[datetime_get]
	-- Add the parameters for the stored procedure here
	@response_message date OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @response_message = (SELECT SYSDATETIME())
END
