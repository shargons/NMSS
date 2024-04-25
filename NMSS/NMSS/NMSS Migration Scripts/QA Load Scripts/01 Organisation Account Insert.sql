
USE CFG_NMSS_QA;
--====================================================================			
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW
--====================================================================


/****** Create table from Mapping view ******/
DROP TABLE IF EXISTS [dbo].[Account_Organization_Insert];
GO
--SELECT TOP 500 *
----INTO [dbo].[Account_Organization_Insert]
--FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Account_org]

/*** Insert only Affiliated Organization records ***/
SELECT DISTINCT E.*
INTO [dbo].[Account_Organization_Insert]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Account_org] E
INNER JOIN [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Affiliation] QA
ON QA.Source_npe5__Organization__c = E.[Data_Warehouse_ID__c]
ORDER BY E.[Data_Warehouse_ID__c]

SELECT * FROM [Account_Organization_Insert]
ORDER BY [Data_Warehouse_ID__c]

/****** Alter table to add ID column ******/

ALTER TABLE [Account_Organization_Insert]
ALTER COLUMN ID nchar(18)


--====================================================================
--INSERTING DATA USING DBAMP - Account
--====================================================================

SELECT * 
FROM [Account_Organization_Insert]


/****** DBAmp Insert Script ******/

--DECLARE @_table_server	nvarchar(255) = DB_NAME()
--EXECUTE	SF_TableLoader
--	@operation	=	'Insert:bulkapi2'
--	,@table_server	=	@_table_server
--	,@table_name	=	'Account_Organization_Insert'

EXEC SF_TableLoader 'Insert','CFG_NMSS_QA','Account_Organization_Insert'

--====================================================================
--ERROR RESOLUTION - Account
--====================================================================

SELECT *
FROM [dbo].[Account_Organization_Insert_Result]
WHERE Error <> 'Operation Successful.'


/***** Organization Delete *****/
drop table Account_Organization_Delete
SELECT SFID AS ID
into Account_Organization_Delete
FROM [dbo].[XREF_Account_Org]
WHERE DWID IS NOT NULL

EXEC SF_TableLoader 'Delete','CFG_NMSS_QA','Account_Organization_Delete'

--====================================================================
--POPULATING XREF TABLES- Account
--====================================================================
INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_Account_Org]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT
 ID AS SFID
,[Data_Warehouse_ID__c] AS [DWID]
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM [Account_Organization_Insert_Result]
WHERE Error = 'Operation Successful.'

--DROP TABLE Account_Lookup
SELECT
 ID 
,[Data_Warehouse_ID__c] 
INTO Account_Lookup
FROM [Account_Organization_Insert_Result]
WHERE Error = 'Operation Successful.'