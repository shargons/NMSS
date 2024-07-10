USE CFG_NMSS_QA;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FA Payment
--====================================================================


--DROP table FA_Payment__c_Direct_Load
SELECT F.[ID]
	  ,[DWUI_Interaction_ID__c]
	  ,[DWUI_Constituent_Process_ID__c]
      ,[Source_FA_Request]
	  ,F2.SFID AS FA_Request__c
      ,[Source_CaseID]
	  ,C.Id AS Case__c
      ,[Source_Constituent__c]
	  ,C2.SFID AS Constituent__c
      ,[Payment_Date__c]
      ,[Amount__c]
      ,F.[OwnerId]
      ,F.[CreatedById]
      ,F.[Status__c]
  INTO FA_Payment__c_Direct_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFAPayment] F
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Case] C 
	   ON C.Data_Warehouse_ID__c = F.[Source_CaseID]
	   INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C2
	   ON F.[Source_Constituent__c] = C2.DWID
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[XREF_FARequest] F2
	   ON F.[DWUI_Interaction_ID__c] = F2.DWID

/******* Check Load table *********/
SELECT *
FROM FA_Payment__c_Direct_Load


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FA_Payment__c_Direct_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - FA Payment
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FA_Payment__c_Direct_Load'

SELECT * FROM FA_Payment__c_Direct_Load_Result where Error <>'Operation Successful.'

select DISTINCT Error from FA_Payment__c_Direct_Load_Result

--====================================================================
--ERROR RESOLUTION - FA Payment
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE   FA_Payment__c_Direct_DELETE

SELECT ID INTO FA_Payment__c_Direct_DELETE FROM FA_Payment__c_Direct_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FA_Payment__c_Direct_DELETE'



--====================================================================
--POPULATING XREF TABLES- FA Payment
--====================================================================

INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_FAPayment]
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
FROM FA_Payment__c_Direct_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[FAPayment_Lookup];
--GO

SELECT ID ,[DWUI_Interaction_ID__c] as LegacyID
INTO [dbo].[FAPayment_Lookup]
FROM FA_Payment__c_Direct_Load_Result
where Error = 'Operation Successful.'

--====================================================================
-- Update Case Status for Open FA Requests
--====================================================================
-- Case Status Update
SELECT DISTINCT
	  C.Id 
	  ,'FA Maintenance' as Status
  INTO Case_FA_Open_Status_Update
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFAPayment] F
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Case] C 
	   ON C.Data_Warehouse_ID__c = F.[Source_CaseID]
	   INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C2
	   ON F.[Source_Constituent__c] = C2.DWID
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[XREF_FARequest] F2
	   ON F.[DWUI_Interaction_ID__c] = F2.DWID
 WHERE F.CompleteFlag = 0

 /******* DBAmp Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Case_FA_Open_Status_Update'
