
USE [CFG_NMSS_PREPROD];
--====================================================================
--INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Household
--====================================================================
DROP TABLE IF EXISTS [dbo].[Account_HH_LOAD];
GO


SELECT  [Id]
      ,[Data_Warehouse_ID__c]
      ,[Name]
      ,[Source_RecordTypeId] AS RecordTypeId
      ,[CreatedDate]
      ,[LastModifiedDate]
      ,[Active__c]
      ,[Market__c]
INTO Account_HH_LOAD
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Account_Household]



--====================================================================
--INSERTING DATA USING DBAMP - Household
--====================================================================

ALTER TABLE Account_HH_LOAD
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Account_HH_LOAD

/******* Insert DBAmp Script *********/
EXEC SF_TableLoader 'Insert','CFG_NMSS_PREPROD','Account_HH_LOAD'

--====================================================================
--ERROR RESOLUTION - Household
--====================================================================
SELECT * FROM Account_HH_LOAD_Result where Error <> 'Operation Successful.'

select distinct Error from Account_HH_LOAD_Result

/******* DBAmp Delete Script *********/
DROP TABLE IF EXISTS [dbo].[Account_HH_DELETE];
GO
  
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Account_HH_DELETE'

INSERT INTO Account_HH_DELETE(Id) 
SELECT Id FROM Account_HH_LOAD_Result 
WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Account_HH_DELETE'

SELECT * FROM Account_HH_DELETE_Result WHERE Error <> 'Operation Successful.'

--====================================================================
--POPULATING XREF TABLES- Household
--====================================================================
-- SFINTEGRATION SERVER
INSERT INTO [NMSS_SRC].[CFG_NMSS_QA].[dbo].[XREF_Account_Household]
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
FROM Account_HH_LOAD_Result
WHERE Error = 'Operation Successful.'

-- FOR DBAMP TOOLS SERVER
INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_Account_Household]
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
FROM Account_HH_LOAD_Result
WHERE Error = 'Operation Successful.'

DROP TABLE IF EXISTS [dbo].[Account_HH_Lookup] ;
GO

-- Account HH Lookup table
SELECT ID,[Data_Warehouse_ID__c]
INTO [Account_HH_Lookup]
FROM Account_HH_LOAD_Result
WHERE Error = 'Operation Successful.' 