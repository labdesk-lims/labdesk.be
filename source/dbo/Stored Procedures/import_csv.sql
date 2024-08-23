-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[import_csv]
	-- Add the parameters for the stored procedure here
	@strPath VARCHAR(MAX),
	@message BIT OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRY
		DECLARE @sql varchar(max)
		-- DECLARE @csv TABLE(id int, request int, method int, instrument int, keyword nvarchar(max), value_txt nvarchar(max))

		-- Import with universal file format
		SET @sql = '
		BULK INSERT import
		FROM '''+@strPath+''' WITH
		(
			DATAFILETYPE=''char'',
			FIRSTROW=2,
			FIELDTERMINATOR = '','', 
			ROWTERMINATOR = ''\n''
		)
		'
		EXEC (@sql)
		SET @message = 1
	END TRY
	BEGIN CATCH
		SET @message = 0
	END CATCH
END
