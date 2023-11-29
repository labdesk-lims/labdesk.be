-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[mailqueue_process]
	-- Add the parameters for the stored procedure here
	@strFolder NVARCHAR(200) -- the temporary folder
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i INT
	DECLARE @j INT
	DECLARE @k INT
	DECLARE @r NVARCHAR(MAX)
	DECLARE @t NVARCHAR(MAX)
	DECLARE @s NVARCHAR(MAX)
	DECLARE @cc NVARCHAR(MAX)
	DECLARE @subject NVARCHAR(MAX)
	DECLARE @body NVARCHAR(MAX)

	-- Create temporary folder if it does not exist
	EXEC folder_create @strFolder

	DECLARE mailqueue_cur CURSOR FOR SELECT id FROM mailqueue WHERE processed_at IS NULL ORDER BY request

	OPEN mailqueue_cur
	FETCH NEXT FROM mailqueue_cur INTO @i
	WHILE @@FETCH_STATUS = 0
	BEGIN

		DECLARE attachment_rqt CURSOR FOR SELECT id FROM attachment WHERE request = (SELECT request FROM mailqueue WHERE id = @i) AND attach = 1 ORDER BY id
		-- Prepare request attachments in case of provided request
		IF (SELECT request FROM mailqueue WHERE id = @i) IS NOT NULL
		BEGIN
			OPEN attachment_rqt
			FETCH NEXT FROM attachment_rqt INTO @j
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC attachment_save @j, @strFolder, @s OUT
				IF @t <> '' SET @t = CONCAT(@t,';', @s) ELSE SET @t =  @s
				FETCH NEXT FROM attachment_rqt INTO @j
			END
			CLOSE attachment_rqt
			DEALLOCATE attachment_rqt
		END

		DECLARE attachment_inv CURSOR FOR SELECT id FROM attachment WHERE billing_customer = (SELECT billing_customer FROM mailqueue WHERE id = @i) AND attach = 1 ORDER BY id
		-- Prepare invoice attachments in case of provided request
		IF (SELECT billing_customer FROM mailqueue WHERE id = @i) IS NOT NULL
		BEGIN
			OPEN attachment_inv
			FETCH NEXT FROM attachment_inv INTO @j
			WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC attachment_save @j, @strFolder, @s OUT
				IF @t <> '' SET @t = CONCAT(@t,';', @s) ELSE SET @t =  @s
				FETCH NEXT FROM attachment_inv INTO @j
			END
			CLOSE attachment_inv
			DEALLOCATE attachment_inv
		END

		-- Prepare recipients list
		DECLARE recipients_cur CURSOR FOR SELECT id FROM contact WHERE customer = (SELECT customer FROM request WHERE id = (SELECT request FROM mailqueue WHERE id = @i)) ORDER BY id

		OPEN recipients_cur
		FETCH NEXT FROM recipients_cur INTO @k
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @s = (SELECT email FROM contact WHERE id = @k)
			IF @r <> '' SET @r = CONCAT(@r,';', @s) ELSE SET @r = @s
			FETCH NEXT FROM recipients_cur INTO @k
		END
		CLOSE recipients_cur
		DEALLOCATE recipients_cur

		-- Get CC E-Mail
		SET @cc = (SELECT cc_email FROM request WHERE id = (SELECT request FROM mailqueue WHERE id = @i))

		-- Send mail
		IF (SELECT recipients FROM mailqueue WHERE id = @i) IS NOT NULL
			SET @r = (SELECT recipients FROM mailqueue WHERE id = @i)

		-- Concat recipients if cc applies
		IF @cc IS NOT NULL
			SET @r = CONCAT(@r, ';', @cc)

		SET @subject = (SELECT subject FROM mailqueue WHERE id = @i)
		SET @body = (SELECT body FROM mailqueue WHERE id = @i)

		EXEC mail_send @r, @subject, @body, @t
		UPDATE mailqueue SET processed_at = GETDATE() WHERE id = @i

		-- Clean attachment list	
		SET @t = ''
		SET @r = ''

		FETCH NEXT FROM mailqueue_cur INTO @i
	END
	CLOSE mailqueue_cur
	DEALLOCATE mailqueue_cur
END
