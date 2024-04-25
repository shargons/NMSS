USE [CFG_NMSS_QA];

--DROP table Affiliation_LOAD

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Affiliation
--====================================================================
DROP TABLE IF EXISTS [dbo].[npe5__Affiliation__c_LOAD];
GO
SELECT 
	   C.[Id]
      ,C.[Data_Warehouse_ID__c]
      ,[CreatedDate]
      ,[LastModifiedDate]
      ,[Source_npe5__Organization__c]
	  ,AL.SFID AS npe5__Organization__c
      ,[Source_npe5__Contact__c]
	  ,CL.SFID AS npe5__Contact__c
      ,[npe5__Description__c]
      ,[npe5__EndDate__c]
      ,[npe5__StartDate__c]
      ,[npe5__Status__c]
      ,[Role__c]
INTO [CFG_NMSS_QA].dbo.npe5__Affiliation__c_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Affiliation] C
INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Account_Org] AL
ON C.[Source_npe5__Organization__c] = AL.DWID
INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Contact] CL
ON C.[Source_npe5__Contact__c] = CL.DWID
WHERE C.ID IS NULL

/******* Check Load table *********/
SELECT *
FROM npe5__Affiliation__c_LOAD

--====================================================================
--INSERTING DATA USING DBAMP - Affiliation
--====================================================================

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE npe5__Affiliation__c_LOAD
ALTER COLUMN ID NVARCHAR(18)


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_QA','npe5__Affiliation__c_LOAD'

SELECT * FROM npe5__Affiliation__c_LOAD_Result where Error = 'Operation Successful.'

select DISTINCT Error from npe5__Affiliation__c_LOAD_Result

--====================================================================
--ERROR RESOLUTION - Affiliation
--====================================================================


/******* DBAmp Delete Script *********/
DROP TABLE  npe5__Affiliation__c_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, ' npe5__Affiliation__c_DELETE'

SELECT Id INTO  npe5__Affiliation__c_DELETE FROM npe5__Affiliation__c_LOAD_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'npe5__Affiliation__c_DELETE'

--====================================================================
--POPULATING XREF TABLES- Affiliation
--====================================================================
INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_Affiliation]
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
FROM npe5__Affiliation__c_LOAD_Result
WHERE Error = 'Operation Successful.'

-- Contact Lookup
DROP TABLE IF EXISTS [dbo].[npe5__Affiliation_Lookup];
GO
SELECT
 ID
,[Data_Warehouse_ID__c]
INTO [CFG_NMSS_QA].[dbo].[npe5__Affiliation_Lookup]
FROM npe5__Affiliation__c_LOAD_Result
WHERE Error = 'Operation Successful.'