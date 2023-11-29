-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 April
-- Description:	Diff between two xmls
-- =============================================
CREATE FUNCTION [dbo].[xml_diff] 
(	
	-- Add the parameters for the function here
	@pk nvarchar(max),
	@x XML, 
	@y XML
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	WITH A AS (
	SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@x.nodes('row/*') AS N(x)
	),
	B AS (
	SELECT
		N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
		N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
	FROM
		@y.nodes('row/*') AS N(x)
	)
	SELECT
		@pk AS pk,
		COALESCE(A.elem_name, B.elem_name) AS elem_name,
		--A.elem_text AS value_old,
		--B.elem_text AS value_new
		-- Use cast to reduce max length
		CAST(A.elem_text AS nvarchar(256)) AS value_old,
		CAST(B.elem_text AS nvarchar(256)) AS value_new
	FROM
		A
		FULL OUTER JOIN
		B
		ON A.elem_name = B.elem_name
	WHERE
		A.elem_text <> B.elem_text
)

