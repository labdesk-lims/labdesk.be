-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 February
-- Description:	-
-- =============================================
CREATE PROCEDURE [dbo].[mail_send] 
	-- Add the parameters for the stored procedure here
	@p_recipients VARCHAR(MAX),
	@p_subject VARCHAR(256),
	@p_body VARCHAR(MAX),
	@p_filenames VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @mail_profile VARCHAR(256)
	DECLARE @s_subject NVARCHAR(MAX)
	DECLARE @s_body NVARCHAR(MAX)

	SET @mail_profile = (SELECT TOP 1 email_profile FROM setup)

	-- Substitue sql statements if applies
	EXEC message_substitute_sql @p_subject, @s_subject OUT
	EXEC message_substitute_sql @p_body, @s_body OUT

	EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = @mail_profile,  
    @recipients = @p_recipients,  
	@body_format = 'HTML',
	@subject = @s_subject,
    @body = @s_body,
	@file_attachments = @p_filenames;
END
