
USE CFG_NMSS_PREPROD;
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
INTO [CFG_NMSS_PREPROD].dbo.Case_C_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_CareManagementCases]   C
INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] CL
ON C.[Source_WhoId] = CL.DWID

/******* Check Load table *********/

select * from Case_C_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_C_LOAD
ALTER COLUMN ID NVARCHAR(18)

select count(*),Data_Warehouse_ID__c
from Case_C_LOAD
group by Data_Warehouse_ID__c
--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','Case_C_LOAD'


UPDATE A
SET A.CreatedDate = cp.CreatedDate
FROM Case_LOAD_2 A
LEFT JOIN NMSS_SRC.TommiQA1.dbo.apfx_ConstituentKeyProcess cp
ON A.Data_Warehouse_ID__c = cp.InteractionID
WHERE ClosedDate < A.CreatedDate

UPDATE A
SET CreatedDate = DATEADD(hour, 9, DATEDIFF(DAY, 0, CreatedDate))

SELECT A.*
FROM Case_LOAD_2 A
WHERE 
ClosedDate < A.CreatedDate

SELECT * FROM Case_LOAD_5

SELECT * 
INTO Case_LOAD_5
FROM Case_LOAD_4_Result 
where Error LIKE 'FIELD_INTEGRITY_EXCEPTION%'

UPDATE A
SET 
ClosedDate = DATEADD(MONTH,2, DATEDIFF(DAY, 0, CreatedDate))
FROM Case_LOAD_5 A
where  Error LIKE '%ClosedDate%'


UPDATE A
SET CreatedDate = DATEADD(YEAR,-25, DATEDIFF(DAY, 0, CreatedDate))
FROM Case_LOAD_5 A
where  Error LIKE '%future%'
AND Year(CreatedDate)>2024
 

select * from Case_LOAD_3
where YEAR(CreatedDate) > 2026

select DISTINCT Error from Case_LOAD_4_Result

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

SELECT ID ,[Data_Warehouse_ID__c]
INTO [dbo].[Case_Lookup]
FROM Case_C_LOAD_Result
where Error = 'Operation Successful.'
