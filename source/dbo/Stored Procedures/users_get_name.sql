-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 January
-- Description:	-
-- ==============================================
CREATE PROCEDURE [dbo].[users_get_name]
	-- Add the parameters for the stored procedure here
	@response_message NVARCHAR(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	BEGIN TRY
		SET @response_message = SUSER_NAME()
	END TRY

	BEGIN CATCH
		SET @response_message = NULL
	END CATCH
END
