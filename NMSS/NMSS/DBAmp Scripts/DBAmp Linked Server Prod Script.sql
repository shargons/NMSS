USE [master]
GO

/****** Object:  LinkedServer [CFG_NMSS_PROD]    Script Date: 6/14/2024 8:10:14 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'CFG_NMSS_PROD', @srvproduct=N'Salesforce', @provider=N'MSOLEDBSQL', @datasrc=N'localhost,1435', @provstr=N'App=https://nmss.my.salesforce.com/'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'CFG_NMSS_PROD',@useself=N'False',@locallogin=NULL,@rmtuser=N'integrations@nmss.org',@rmtpassword='WhereCRMandDWM33tEnEKlS9rL8TEZZru1qVBP9BC'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PROD', @optname=N'remote proc transaction promotion', @optvalue=N'false'
GO


