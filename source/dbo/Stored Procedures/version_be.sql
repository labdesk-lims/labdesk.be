-- ==================================================
-- Author:		Kogel, Lutz
-- Create date: 2022 June
-- Description:	Used to identify the backend version
-- ==================================================
CREATE PROCEDURE [dbo].[version_be]
	-- Add the parameters for the stored procedure here
	@version_be nvarchar(256) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @version_be = 'v2.9.0'
END