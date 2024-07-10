
USE CFG_NMSS_PROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Relationships
--====================================================================
DROP TABLE IF EXISTS [dbo].[npe4__Relationship__c_LOAD];
GO
SELECT DISTINCT C.[Id]
      ,C.[Data_Warehouse_ID__c]
      ,C.[CreatedDate]
      ,C.[LastModifiedDate]
      ,C.[Source_npe4__Contact__c]
	  ,CL.SFID AS [npe4__Contact__c]
      ,C.[npe4__Description__c]
      ,C.[Source_npe4__ReciprocalRelationship__c]
      ,C.[Source_npe4__RelatedContact__c]
	  ,AL.SFID AS [npe4__RelatedContact__c]
      ,C.[npe4__Status__c]
      ,C.[npe4__Type__c]
      ,ISNULL(C.[Authorized_to_Discuss__c],0) as [Authorized_to_Discuss__c]
INTO [CFG_NMSS_PROD].dbo.npe4__Relationship__c_LOAD
FROM [CFG_NMSS_PROD].[dbo].[vw_DW_SFDC_Relationship] C
INNER JOIN [CFG_NMSS_PROD].dbo.[XREF_Contact] AL
ON C.[Source_npe4__RelatedContact__c] = AL.DWID
INNER JOIN [CFG_NMSS_PROD].dbo.[XREF_Contact] CL
ON C.[Source_npe4__Contact__c] = CL.DWID


/******* Check Load table *********/
SELECT *
FROM npe4__Relationship__c_LOAD

--====================================================================
--INSERTING DATA USING DBAMP - Relationships
--====================================================================


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE npe4__Relationship__c_LOAD
ALTER COLUMN ID NVARCHAR(18)


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','npe4__Relationship__c_LOAD'

SELECT * FROM npe4__Relationship__c_LOAD_Result where Error ='Operation Successful.'

select DISTINCT Error from npe4__Relationship__c_LOAD_Result

--====================================================================
--ERROR RESOLUTION - Relationships
--====================================================================

/******* DBAmp Delete Script *********/
DROP TABLE  npe4__Relationship__c_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, ' npe4__Relationship__c_DELETE'

SELECT Id INTO  npe4__Relationship__c_DELETE FROM npe4__Relationship__c_LOAD_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'npe4__Relationship__c_DELETE'


--====================================================================
--POPULATING XREF TABLES- Relationships
--====================================================================
INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_Relationship]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT
 ID AS SFID
,[Data_Warehouse_ID__c] as DWID
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM npe4__Relationship__c_LOAD_Result
WHERE Error = 'Operation Successful.'

INSERT INTO [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Relationship]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT
 ID AS SFID
,[Data_Warehouse_ID__c] as DWID
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM npe4__Relationship__c_LOAD_Result
WHERE Error = 'Operation Successful.'


-- Relationship Lookup
--DROP TABLE [npe4__Relationship__c_Lookup]
SELECT
 ID
,[Data_Warehouse_ID__c]
INTO [dbo].[npe4__Relationship__c_Lookup]
FROM npe4__Relationship__c_LOAD_Result
WHERE Error = 'Operation Successful.'