-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Create audit trail from record
-- =============================================
CREATE PROCEDURE [dbo].[audit_xml_diff]
	-- Add the parameters for the stored procedure here
	@table_name nvarchar(128),
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @x XML, @y XML
	DECLARE @l xml_diff_list
	DECLARE audit_xml_diff CURSOR FOR SELECT id FROM audit WHERE table_name = @table_name AND table_id = @id

	OPEN audit_xml_diff
	FETCH NEXT FROM audit_xml_diff INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @x = (SELECT value_old FROM audit WHERE id = @i)
		SET @y = (SELECT value_new FROM audit WHERE id = @i)

		IF @x IS NOT NULL AND @y IS NOT NULL
			INSERT INTO @l SELECT * FROM xml_diff(@i, @x, @y)

		IF @x IS NULL
		BEGIN
			WITH A AS (
			SELECT
				N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
				N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
			FROM
				@y.nodes('row/*') AS N(x)
			) INSERT INTO @l SELECT @i, elem_name, NULL, elem_text FROM A
		END

		IF @y IS NULL
			BEGIN
			WITH A AS (
			SELECT
				N.x.value('local-name(.)', 'nvarchar(128)') AS elem_name,
				N.x.value('text()[1]', 'nvarchar(max)') AS elem_text
			FROM
				@x.nodes('row/*') AS N(x)
			) INSERT INTO @l SELECT @i, elem_name, NULL, elem_text FROM A
		END

		FETCH NEXT FROM audit_xml_diff INTO @i
	END
	CLOSE audit_xml_diff
	DEALLOCATE audit_xml_diff

	SELECT l.elem_name, l.value_old, l.value_new, a.changed_by, a.changed_at FROM @l AS l INNER JOIN audit AS a ON l.pk = a.id ORDER BY a.id ASC
END
