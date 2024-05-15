
--DROP TABLE Account_RelationshipRelatedContact_HH_Insert
SELECT DISTINCT HH.* 
INTO Account_RelationshipRelatedContact_HH_Insert
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[Contact_RelatedRelationship_Insert] C
LEFT JOIN
[NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Account_Household] HH
ON C.Source_AccountId = HH.[Data_Warehouse_ID__c]


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Account_RelationshipRelatedContact_HH_Insert
ALTER COLUMN ID NVARCHAR(18)

EXEC sp_rename 'dbo.Account_RelationshipRelatedContact_HH_Insert.Source_RecordTypeId', 'RecordTypeId', 'COLUMN';

SELECT * FROM Account_RelationshipContact_HH_Insert

/******* Insert DBAmp Script *********/
EXEC SF_TableLoader 'Insert','CFG_NMSS_QA','Account_RelationshipRelatedContact_HH_Insert'

/******* Error Resolution *********/
SELECT * FROM Account_RelationshipRelatedContact_HH_Insert_Result where Error <> 'Operation Successful.'

select distinct Error from Account_HH_LOAD_Result

DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Account_HH_DELETE'

INSERT INTO Account_HH_DELETE(Id) SELECT Id FROM Account_RelationshipRelatedContact_HH_Insert_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Account_HH_DELETE'

SELECT * FROM Account_RelationshipRelatedContact_HH_Insert_Result WHERE Error <> 'Operation Successful.'

/******* Create Lookup Table *********/
--====================================================================
--POPULATING XREF TABLES- Household
--====================================================================
INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_Account_Household]
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
FROM Account_RelationshipRelatedContact_HH_Insert_Result
WHERE Error = 'Operation Successful.'


INSERT INTO [CFG_NMSS_QA].dbo.Account_HH_Lookup
SELECT ID,[Data_Warehouse_ID__c]
FROM Account_RelationshipRelatedContact_HH_Insert_Result
WHERE Error = 'Operation Successful.'