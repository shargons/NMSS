USE CFG_NMSS_PROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - InterestedCase__c 
--====================================================================


--DROP table InterestedCase__c_Load
SELECT A.*
  INTO InterestedCase__c_Load_Rem
  FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_CaseInterestRT] A
      INNER JOIN Case_LOAD_Rem_Result B
  ON A.DWUI_Interaction_ID__c = B.Data_Warehouse_ID__c
  WHERE B.Error = 'Operation Successful.'
GO

/******* Check Load table *********/
SELECT *
FROM InterestedCase__c_Load_Rem

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE InterestedCase__c_Load_Rem
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','InterestedCase__c_Load_Rem'

SELECT * 
--INTO InterestedCase__c_Load_2
FROM InterestedCase__c_Load_2_Result 
where Error <> 'Operation Successful.'
AND Error not like '%Duplicate%'

select distinct error from InterestedCase__c_Load_Result

--====================================================================
--ERROR RESOLUTION - Case
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  InterestedCase__c_DELETE

SELECT ID INTO InterestedCase__c_DELETE FROM InterestedCase__c_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'InterestedCase__c_DELETE'



--====================================================================
--POPULATING XREF TABLES- Case Interest Response Type
--====================================================================
--TRUNCATE table XREF_CaseInterest
INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_CaseInterest]
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
FROM InterestedCase__c_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[CaseInterest_Lookup];
--GO
INSERT INTO [dbo].[CaseInterest_Lookup]
SELECT ID ,[DWUI_Interaction_ID__c] as Data_Warehouse_ID__c
FROM InterestedCase__c_Load_Result
where Error = 'Operation Successful.'

