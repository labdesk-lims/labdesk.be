/*
 Konfigurations-Skript vor der Bereitstellung							
--------------------------------------------------------------------------------------
 Diese Datei enthält SQL-Anweisungen, die vor dem Buildskript ausgeführt werden.	
 Schließen Sie mit der SQLCMD-Syntax eine Datei in das Skript vor der Bereitstellung ein.			
 Beispiel:   :r .\myfile.sql								
 Verweisen Sie mit der SQLCMD-Syntax auf eine Variable im Skript vor der Bereitstellung.		
 Beispiel:   :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

RECONFIGURE WITH OVERRIDE;
-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;  
GO
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO
EXECUTE sp_configure 'xp_cmdshell', 1;  
GO
RECONFIGURE;  
GO
EXECUTE sp_configure 'external scripts enabled', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
