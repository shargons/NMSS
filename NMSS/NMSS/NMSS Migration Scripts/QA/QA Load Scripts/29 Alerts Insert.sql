
USE CFG_NMSS_QA;

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Warning
--====================================================================
--DROP TABLE IF EXISTS [dbo].[Warning__c_LOAD];
--GO
SELECT C.*,HL.SFID as Contact__c
INTO [CFG_NMSS_PREPROD].dbo.Warning__c_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Warning__c] C
LEFT JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] HL
ON C.[Source_Contact__c] = HL.DWID
WHERE HL.SFID IS NOT NULL

/******* Check Load table *********/
SELECT * FROM Warning__c_LOAD

--====================================================================
--INSERTING DATA USING DBAMP - Individual
--====================================================================


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Warning__c_LOAD
ALTER COLUMN ID NVARCHAR(18)


EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','Warning__c_LOAD'

SELECT * FROM Warning__c_LOAD_Result where Error = 'Operation Successful.'

select DISTINCT  Error from Warning__c_LOAD_Result

--====================================================================
--ERROR RESOLUTION - Individual
--====================================================================

SELECT * FROM Warning__c_LOAD_Result where Error <> 'Operation Successful.'

/******* DBAmp Delete Script *********/
DROP TABLE Warning__c_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Warning__c_DELETE'

INSERT INTO Warning__c_DELETE(Id) SELECT Id FROM Warning__c_LOAD_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Warning__c_DELETE'


--====================================================================
--POPULATING XREF TABLES- Warnings
--====================================================================
--TRUNCATE TABLE [CFG_NMSS_QA].[dbo].[XREF_DW_SFDC_Warning__c]
INSERT INTO [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_DW_SFDC_Warning__c]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT
 ID AS SFID
,[Data_Warehouse_ID__c]
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM Warning__c_LOAD_Result
WHERE Error = 'Operation Successful.'

-- Warning Lookup
DROP TABLE IF EXISTS [dbo].[Warning_Lookup];
GO
SELECT
 ID
,[Data_Warehouse_ID__c]
INTO [CFG_NMSS_QA].[dbo].[Warning_Lookup]
FROM Warning__c_LOAD_Result
WHERE Error = 'Operation Successful.'