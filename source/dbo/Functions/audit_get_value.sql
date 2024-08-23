-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[audit_get_value]
(
	-- Add the parameters for the function here
	@table_name VARCHAR(255),
	@table_id INT,
	@clmn_name VARCHAR(255),
	@changed_at DATETIME
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @elem_text NVARCHAR(MAX)

	-- Add the T-SQL statements to compute the return value here
	DECLARE @x XML
	SET @x = (SELECT TOP 1 value_new FROM audit WHERE table_name = @table_name AND table_id = @table_id AND changed_at <= @changed_at ORDER BY id DESC)

	SET @elem_text =
	(
	SELECT TOP 1 elem_text FROM (SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@x.nodes('row/*') AS N(x)) As a WHERE elem_name = @clmn_name
	)

	-- Return the result of the function
	RETURN @elem_text

END
