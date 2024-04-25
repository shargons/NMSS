USE [master]
GO

/****** Object:  LinkedServer [CFG_NMSS_QA]    Script Date: 2/23/2024 8:47:07 AM ******/
EXEC master.dbo.sp_dropserver @server=N'CFG_NMSS_QA', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [CFG_NMSS_QA]    Script Date: 2/23/2024 8:47:07 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'CFG_NMSS_QA', @srvproduct=N'Salesforce', @provider=N'MSOLEDBSQL',@datasrc=N'localhost,1435', @provstr=N'App=https://nmss--cfgqa.sandbox.my.salesforce.com'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'CFG_NMSS_QA',@useself=N'False',@locallogin=NULL,@rmtuser=N'sharon.gonsalves@nmss.org.cfgqa',@rmtpassword='K8YYfqgG5YEhz8ocfjNG1JKKulH5RO55HEbjjhJAO'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'collation compatible', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'CFG_NMSS_QA', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


