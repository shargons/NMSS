
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
INTO [CFG_NMSS_PROD].dbo.Case_LOAD
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_Case] C
INNER JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] CL
ON C.[Source_WhoId] = CL.DWID

/******* Check Load table *********/

select * from Case_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_LOAD
ALTER COLUMN ID NVARCHAR(18)

select count(*),Data_Warehouse_ID__c
from Case_LOAD
group by Data_Warehouse_ID__c
--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_LOAD_3'


DROP TABLE Case_Load_2

SELECT A.*
INTO Case_Load_2
FROM Case_Load A
LEFT JOIN
[Case] B
ON A.[Data_Warehouse_ID__c] = B.[Data_Warehouse_ID__c]
WHERE B.ID IS NULL

select * 
--into Case_Load_3
from Case_Load_3_Result
where error <> 'Operation Successful.'
and error like '%FIELD%'

SELECT * from Case_Load_3

update Case_Load_3
set ClosedDate = GETDATE()







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
FROM [Case]
where Data_Warehouse_Id__c IS NOT NULL


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO

SELECT ID ,[Data_Warehouse_ID__c]
INTO [dbo].[Case_Lookup]
FROM [Case]
where Error = 'Operation Successful.'
