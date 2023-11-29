-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[request_create_subrequest] 
	-- Add the parameters for the stored procedure here
	@p_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @pk INT
	DECLARE @ignore ColumnList

	INSERT INTO @ignore VALUES('profile')

	-- Duplicate record of choice
	EXEC row_duplicate 'request', @ignore, @p_id, @pk OUTPUT

	-- Attach newly created request to parent
	UPDATE request SET subrequest = @p_id WHERE id = @p_id
	UPDATE request SET subrequest = @p_id WHERE id = @pk
END