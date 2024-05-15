USE CFG_NMSS_QA;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - InterestedCase__c 
--====================================================================


--DROP table InterestedCase__c_Ctype_Load
SELECT *
  INTO InterestedCase__c_Ctype_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_CaseInterestCType]

/******* Check Load table *********/
SELECT *
FROM InterestedCase__c_Ctype_Load

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE InterestedCase__c_Ctype_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_QA','InterestedCase__c_Ctype_Load'

SELECT * FROM InterestedCase__c_Ctype_Load_Result where Error ='Operation Successful.'

select DISTINCT Error from InterestedCase__c_Ltype_Load_Result

--====================================================================
--ERROR RESOLUTION - Case Interest
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  InterestedCase__c_DELETE

SELECT ID INTO InterestedCase__c_DELETE FROM InterestedCase__c_Ltype_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'InterestedCase__c_DELETE'

SELECT * FROM InterestedCase__c_DELETE_Result WHERE Error <> 'Operation Successful.'


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
SELECT ID AS SFID,[LegacyID__c] AS DWID
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM InterestedCase__c_Ctype_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[Case_Lookup];
--GO
INSERT INTO [dbo].[CaseInterest_Lookup]
SELECT ID ,[LegacyID__c]
FROM InterestedCase__c_Ctype_Load_Result
where Error = 'Operation Successful.'
