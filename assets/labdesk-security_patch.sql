USE [master];

GO
ALTER TRIGGER prevent_login
ON ALL SERVER WITH EXECUTE AS 'sa'
FOR LOGON
AS
BEGIN
	IF APP_NAME() != 'labdesk-ui' And (
	ORIGINAL_LOGIN() = 'SERVER\username' Or 
	ORIGINAL_LOGIN() = 'SERVER\username'
	)
	BEGIN
		RAISERROR('You are not allowed to login using this appliation.', 16, 1);
		ROLLBACK; --Disconnect the session
	END
END