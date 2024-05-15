USE CFG_NMSS_QA;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FA Request
--====================================================================


--DROP table FA_Request__c_Direct_Load
SELECT ID
	  ,[DWUI_Interaction_ID__c]
      ,[DWUI_Interaction_Detail_ID__c]
      ,[DWUI_Constituent_Key_Process_ID__c]
      ,[Source_Beneficiary_Contact__c]
	  ,C2.SFID AS Beneficiary_Contact__c
      ,[CreatedDate]
      ,[Source_CaseID]
	  ,C.SFID AS Case__c
      ,[Decision_Date__c]
      ,[Status__c]
      ,[Requested_Amount__c]
      ,[Award_Amount__c]
      ,[Award_Type__c]
      ,[Award_Description__c]
      ,[Benefit_Type__c]
      ,[Spend_Category__c]
      ,[OwnerId]
      ,[CreatedById]
  INTO FA_Request__c_Direct_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFARequest] F
	   INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Case] C 
	   ON C.DWID = F.[Source_CaseID]
	   INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Contact] C2
	   ON F.[Source_Beneficiary_Contact__c] = C2.DWID

/******* Check Load table *********/
SELECT *
FROM FA_Request__c_Direct_Load

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FA_Request__c_Direct_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - FA Request
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_QA','FA_Request__c_Direct_Load'

SELECT * FROM FA_Request__c_Direct_Load_Result where Error ='Operation Successful.'

select DISTINCT Error from FA_Request__c_Direct_Load_Result

--====================================================================
--ERROR RESOLUTION - Case Interest
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  FA_Request__c_Direct_DELETE

SELECT ID INTO FA_Request__c_Direct_DELETE FROM FA_Request__c_Direct_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FA_Request__c_Direct_DELETE'



--====================================================================
--POPULATING XREF TABLES- Case Interest Response Type
--====================================================================
--TRUNCATE TABLE [CFG_NMSS_QA].[dbo].[XREF_FARequest]
INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_FARequest]
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
FROM FA_Request__c_Direct_Load_Result
where Error = 'Operation Successful.'


DROP TABLE IF EXISTS [dbo].[FARequest_Lookup];
GO

SELECT ID ,[DWUI_Interaction_ID__c] as LegacyID
INTO [dbo].[FARequest_Lookup]
FROM FA_Request__c_Direct_Load_Result
where Error = 'Operation Successful.'
