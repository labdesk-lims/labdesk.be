-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Initialize specific settings
-- =============================================
CREATE PROCEDURE [dbo].[lims_initialize]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	EXEC sp_configure 'external scripts enabled', 1;
	EXEC sp_configure 'xp_cmdshell', 1;
	EXEC sp_configure 'Ole Automation Procedures', 1;
	RECONFIGURE WITH OVERRIDE;
END
