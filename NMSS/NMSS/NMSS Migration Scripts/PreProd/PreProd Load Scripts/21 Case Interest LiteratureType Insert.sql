USE CFG_NMSS_PREPROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - InterestedCase__c 
--====================================================================


--DROP table InterestedCase__c_LT_Load
SELECT *
  INTO InterestedCase__c_LT_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_CaseInterestLT]
GO

/******* Check Load table *********/
SELECT distinct Interest__c
FROM InterestedCase__c_LT_Load

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE InterestedCase__c_LT_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','InterestedCase__c_LT_Load'

SELECT * FROM InterestedCase__c_LT_Load_Result where Error ='Operation Successful.'

select DISTINCT DWUI_Interaction_ID__c,Error from InterestedCase__c_LT_Load_Result


--====================================================================
--ERROR RESOLUTION - Case
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  InterestedCase__c_DELETE

SELECT ID INTO InterestedCase__c_DELETE FROM InterestedCase__c_LT_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'InterestedCase__c_DELETE'



--====================================================================
--POPULATING XREF TABLES- Case Interest Response Type
--====================================================================

INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_CaseInterest]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT ID AS SFID,[DWUI_Interaction_ID__c] AS DWID
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM InterestedCase__c_LT_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO

SELECT ID ,[DWUI_Interaction_ID__c] as Data_Warehouse_ID__c
INTO [dbo].[CaseInterest_Lookup]
FROM InterestedCase__c_LT_Load_Result
where Error = 'Operation Successful.'
