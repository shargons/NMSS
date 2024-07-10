
USE CFG_NMSS_PROD;
--DROP table Case_LOAD

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Cases
--====================================================================
--DROP TABLE IF EXISTS [dbo].[Case_LOAD];
--GO
SELECT
	   C.[Id]
      ,C.[Data_Warehouse_ID__c]
      ,C.[Source_WhoId]
	  ,CL.SFID AS WhoId
	  ,CL.SFID AS ContactID
      ,C.[ClosedDate]
      ,C.[Origin]
      ,C.[Type]
      ,C.[Confidential__c]
      ,C.[Status]
      ,C.[CreatedDate]
      ,C.[Description]
      ,C.[Subject]
      ,C.[OwnerId]
	  ,C.[CreatedById]
      ,C.[LastModifiedById]
	  ,C.[RecordtypeId]
INTO [CFG_NMSS_PROD].dbo.Case_C_LOAD1
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_CareManagementCases]   C
INNER JOIN [CFG_NMSS_PROD].[dbo].[XREF_Contact] CL
ON C.[Source_WhoId] = CL.DWID

/******* Check Load table *********/

UPDATE Case_C_LOAD
SET ClosedDate = NULL
WHERE ClosedDate = 'NULL'

UPDATE Case_C_LOAD
SET CreatedDate = TRY_CAST(CreatedDate AS datetime2)

select * from Case_C_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_C_LOAD
ALTER COLUMN ID NVARCHAR(18)

select count(*),Data_Warehouse_ID__c
from Case_C_LOAD
group by Data_Warehouse_ID__c
having count(*) > 1
--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_C_LOAD'

select * from Case_C_LOAD_Result
WHERE Error = 'Operation Successful.'

--====================================================================
-- CaseTeamMember Insert
--====================================================================



--====================================================================
--ERROR RESOLUTION - Case
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  Case_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, ' Case_DELETE'

SELECT ID INTO Case_DELETE FROM Case_LOAD_Result where Error ='Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Case_DELETE'



--====================================================================
--POPULATING XREF TABLES- Case
--====================================================================
--TRUNCATE TABLE [CFG_NMSS_QA].[dbo].[XREF_Case]
INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_Case]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT ID AS SFID,[Data_Warehouse_ID__c] AS DWID
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM Case_C_LOAD_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO
INSERT INTO [dbo].[Case_Lookup]
SELECT ID ,[Data_Warehouse_ID__c]
FROM Case_C_LOAD_Result
where Error = 'Operation Successful.'
