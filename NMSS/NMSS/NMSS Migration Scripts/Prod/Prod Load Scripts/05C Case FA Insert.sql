
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
INTO [CFG_NMSS_PROD].dbo.Case_FA_LOAD
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_FACases]   C
INNER JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] CL
ON C.[Source_WhoId] = CL.DWID

/******* Check Load table *********/

select * from Case_FA_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_FA_LOAD
ALTER COLUMN ID NVARCHAR(18)

select count(*),Data_Warehouse_ID__c
from Case_FA_LOAD
group by Data_Warehouse_ID__c
HAVING Count(*) > 1
--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_FA_LOAD_2'


select *
--into Case_FA_LOAD_2
from Case_FA_LOAD_Result
WHERE Error = 'Operation Successful.'
AND Error LIKE '%STRING_TOO_LONG%'

UPDATE Case_FA_LOAD_2
SET Description = LEFT(Description,31999)

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
INSERT INTO [CFG_NMSS_PROD].[dbo].[XREF_Case]
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
FROM Case_FA_LOAD_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO
INSERT INTO [dbo].[Case_Lookup]
SELECT ID ,[Data_Warehouse_ID__c]
FROM Case_FA_LOAD_2_Result
where Error = 'Operation Successful.'
