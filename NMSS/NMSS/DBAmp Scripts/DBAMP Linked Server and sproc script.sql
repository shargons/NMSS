USE master

DECLARE	@Server		VARCHAR(150)	=	@@servername
,		@ORG		VARCHAR(150)	=	'CFG_NMSS_QA'
,		@USERNAME	VARCHAR(150)	=	'sharon.gonsalves@nmss.org.cfgqa'
,		@Password	VARCHAR(150)	=	'K8YYfqgG5YEhz8oc'
,		@Token		VARCHAR(150)	=	'fjNG1JKKulH5RO55HEbjjhJAO'
,		@Location	VARCHAR(255)	=	'https://nmss--cfgqa.sandbox.my.salesforce.com/'
,		@Fullpwd	VARCHAR(255)
,		@sql		VARCHAR(500)

SET		@Fullpwd	=	CONCAT(@Password, @Token)

if exists(select * from sys.servers where name = @ORG)
	EXEC master.dbo.sp_dropserver @server=@ORG, @droplogins='droplogins'

EXEC master.dbo.sp_addlinkedserver @server = @ORG, @srvproduct=N'DBAmp', @provider=N'MSOLEDBSQL', @datasrc=N'Salesforce', @location=@Location
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=@ORG,@useself=N'False',@locallogin=NULL,@rmtuser=@USERNAME ,@rmtpassword=@Fullpwd

EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'collation compatible', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'rpc', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'rpc out', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'use remote collation', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@ORG, @optname=N'remote proc transaction promotion', @optvalue=N'true'

SET	@sql = 'sqlcmd -S ' + @Server + ' -d  ' + @ORG + ' -i ' + ' "C:\Program Files\DBAmp\SQL\Create DBAmp SPROCS.sql" '
----EXEC xp_cmdshell  @sql

SET @SQL = @ORG + '..SF_CreateSysViews ' + @ORG
exec (@SQL)

