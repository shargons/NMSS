USE [master]
GO

/****** Object:  LinkedServer [CFG_NMSS_PREPROD]    Script Date: 5/8/2024 11:22:17 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'CFG_NMSS_PREPROD', @srvproduct=N'Salesforce', @provider=N'MSOLEDBSQL', @datasrc=N'localhost,1435', @provstr=N'App=https://nmss--preprod.sandbox.my.salesforce.com/'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'CFG_NMSS_PREPROD',@useself=N'False',@locallogin=NULL,@rmtuser=N'integrations@nmss.org.preprod',@rmtpassword='WhereCRMandDWM33tEnEKlS9rL8TEZZru1qVBP9BC'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_PREPROD', @optname=N'remote proc transaction promotion', @optvalue=N'false'
GO


