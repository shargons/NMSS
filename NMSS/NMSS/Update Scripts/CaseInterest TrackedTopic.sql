USE CFG_NMSS_PREPROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - InterestedCase__c 
--====================================================================


--DROP table InterestedCase__c_TT_2_Load
SELECT *
  INTO InterestedCase__c_TT_2_Load
  FROM [CFG_NMSS_PREPROD].[dbo].[vw_DW_CFG_CaseInterestTT]
  wHERE Legacy_Interest__c IN ('TrackedTopic14',
'TrackedTopic16',
'TrackedTopic17',
'TrackedTopic18',
'TrackedTopic19',
'TrackedTopic20',
'TrackedTopic21',
'TrackedTopic22',
'TrackedTopic23',
'TrackedTopic24',
'TrackedTopic25',
'TrackedTopic27',
'TrackedTopic29',
'TrackedTopic32',
'TrackedTopic34',
'TrackedTopic37',
'TrackedTopic39',
'TrackedTopic40',
'TrackedTopic41',
'TrackedTopic42',
'TrackedTopic43',
'TrackedTopic44',
'TrackedTopic45',
'TrackedTopic46',
'TrackedTopic52')
GO

/******* Check Load table *********/
SELECT *
FROM InterestedCase__c_TT_2_Load

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE InterestedCase__c_TT_2_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','InterestedCase__c_TT_2_Load'

SELECT * FROM InterestedCase__c_TT_Load_Result where Error ='Operation Successful.'

select DISTINCT Error from InterestedCase__c_TT_2_Load_Result

--====================================================================
--ERROR RESOLUTION - Case
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  InterestedCase__c_DELETE

SELECT ID INTO InterestedCase__c_DELETE FROM InterestedCase__c_TT_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'InterestedCase__c_DELETE'



--====================================================================
--POPULATING XREF TABLES- Case Interest Response Type
--====================================================================

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
FROM InterestedCase__c_TT_2_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO
INSERT INTO [dbo].[CaseInterest_Lookup]
SELECT ID ,[DWUI_Interaction_ID__c] as Data_Warehouse_ID__c
FROM InterestedCase__c_TT_2_Load_Result
where Error = 'Operation Successful.'
