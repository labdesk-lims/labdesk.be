CREATE TRIGGER prevent_login
ON ALL SERVER WITH EXECUTE AS 'sa'
FOR LOGON
AS
BEGIN
	DECLARE @LoginName sysname
	DECLARE @app nvarchar(255)
	DECLARE @db_name nvarchar(128)

	SET @db_name = DB_NAME()
	SET @app = (SELECT app_name())
	SET @LoginName = ORIGINAL_LOGIN()

	IF @app != 'labdesk-ui' And @db_name = 'labdesk' And (SELECT IS_SRVROLEMEMBER('sysadmin', @LoginName)) != 1
	BEGIN
		ROLLBACK; --Disconnect the session
	END
END