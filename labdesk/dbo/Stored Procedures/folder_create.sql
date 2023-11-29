-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[folder_create]
	-- Add the parameters for the stored procedure here
	@strFolder NVARCHAR(200) -- Folder to be created
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ResultSet TABLE(Directory NVARCHAR(200))
	DECLARE @s NVARCHAR(200)
	DECLARE @tmpFolder NVARCHAR(MAX)

	-- Create table with subfolder names
	INSERT INTO @ResultSet EXEC master.dbo.xp_subdirs 'c:\'

	-- Check if folder already exists
	IF (SELECT COUNT(*) FROM @ResultSet where Directory = @strFolder) = 0
	BEGIN
		-- Create folder
		SET @s = 'MD ' + 'c:\' + @strFolder
		exec master.dbo.xp_cmdshell @s
	END
END
