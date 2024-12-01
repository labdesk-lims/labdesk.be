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