USE [master];

GO
ALTER TRIGGER [prevent_login]
ON ALL SERVER WITH EXECUTE AS 'sa'
FOR LOGON
AS
BEGIN
	IF (ORIGINAL_LOGIN() NOT IN ('sa') AND APP_NAME() NOT IN ('labdesk-ui'))
	BEGIN
		RAISERROR('You are not allowed to login using this appliation.', 16, 1);
		ROLLBACK; --Disconnect the session
	END
END
GO