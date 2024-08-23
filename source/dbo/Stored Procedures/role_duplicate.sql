-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	Duplicate role
-- =============================================
CREATE PROCEDURE [dbo].[role_duplicate]
	-- Add the parameters for the stored procedure here
	@pRole As INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE role_cur CURSOR FOR SELECT id FROM role_permission WHERE role = @pRole
	DECLARE @id_keys table([id] INT)
	DECLARE @id INT
	DECLARE @i INT
	DECLARE @permission INT

	INSERT INTO role (title, description) OUTPUT inserted.id INTO @id_keys VALUES((SELECT title FROM role WHERE id = @pRole) + '_duplicate', (SELECT description FROM role WHERE id = @pRole))

	SET @id = (SELECT TOP 1 id FROM @id_keys)

	OPEN role_cur
	FETCH NEXT FROM role_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @permission = (SELECT permission FROM role_permission WHERE id = @i)
		UPDATE role_permission
		SET
		can_create = (SELECT can_create FROM role_permission WHERE role = @pRole and permission = @permission),
		can_read = (SELECT can_read FROM role_permission WHERE role = @pRole and permission = @permission),
		can_update = (SELECT can_update FROM role_permission WHERE role = @pRole and permission = @permission),
		can_delete = (SELECT can_delete FROM role_permission WHERE role = @pRole and permission = @permission) WHERE role = @id AND permission = @permission
		FETCH NEXT FROM role_cur INTO @i
	END
	CLOSE role_cur
	DEALLOCATE role_cur
END
