-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[attachment_save] 
	-- Add the parameters for the stored procedure here
	@id INT, -- ID of the attachment to be saved
	@strFolder NVARCHAR(200), -- the temporary folder
	@strFile NVARCHAR(200) OUTPUT -- Returns the filename as string
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @init INT
    DECLARE @Data VARBINARY(MAX)
	DECLARE @strPath VARCHAR(MAX)
	DECLARE @fileName NVARCHAR(MAX)

	-- Check if folder exists otherwise create
	EXEC folder_create @strFolder

	SET @FileName = (SELECT file_name FROM attachment WHERE ID = @id)
	
	SELECT @data = blob, @strPath = 'C:\' + @strFolder + '\' + CONVERT(nvarchar, @id) + '_' + @FileName FROM attachment WHERE id = @id;
	
	EXEC sp_OACreate 'ADODB.Stream', @init OUTPUT; -- Create Object
	EXEC sp_OASetProperty @init, 'Type', 1;
	EXEC sp_OAMethod @init, 'Open';
	EXEC sp_OAMethod @init, 'Write', NULL, @data;
	EXEC sp_OAMethod @init, 'SaveToFile', NULL, @strPath, 2;
	EXEC sp_OAMethod @init, 'Close';
	EXEC sp_OADestroy @init; -- Destroy Object

	SET @strFile = @strPath
END
