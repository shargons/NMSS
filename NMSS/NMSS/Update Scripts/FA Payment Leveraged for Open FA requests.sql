USE CFG_NMSS_PREPROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FA Payment
--====================================================================


--DROP table FA_Payment__c_Leveraged_Load
SELECT F.[ID]
	  ,F.[DWUI_Interaction_ID__c]
	  ,F.[DWUI_Constituent_Process_ID__c]
      ,[Source_FA_Request]
	  ,F2.ID AS FA_Request__c
      ,F.[Source_CaseID]
	  ,C.Id AS Case__c
      ,[Source_Constituent__c]
	  ,C2.SFID AS Constituent__c
      ,[Payment_Date__c]
      ,[Amount__c]
      ,F.[OwnerId]
      ,F.[CreatedById]
      ,F.[Status__c]
  INTO FA_Payment__c_Leveraged_2_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_LeveragedFAPayment] F
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Case] C 
	   ON C.Data_Warehouse_ID__c = F.[Source_CaseID]
	   INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C2
	   ON F.[Source_Constituent__c] = C2.DWID
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[FARequest_Leveraged_Lookup] F2
	   ON F.[DWUI_Interaction_ID__c] = F2.LegacyId
  WHERE F.CompleteFlag = 0

/******* Check Load table *********/
SELECT *
FROM FA_Payment__c_Leveraged_2_Load


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FA_Payment__c_Leveraged_2_Load
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - FA Payment
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FA_Payment__c_Leveraged_2_Load'

SELECT * FROM FA_Payment__c_Leveraged_Load_Result where Error <>'Operation Successful.'

select DISTINCT Error from FA_Payment__c_Leveraged_Load_Result

--====================================================================
--ERROR RESOLUTION - FA Payment
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE   FA_Payment__c_Leveraged_DELETE

SELECT ID INTO FA_Payment__c_Leveraged_DELETE FROM FA_Payment__c_Leveraged_Load_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FA_Payment__c_Leveraged_DELETE'



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
FROM FA_Payment__c_Leveraged_2_Load_Result
where Error = 'Operation Successful.'


--DROP TABLE IF EXISTS [dbo].[FAPayment_Leveraged_Lookup];
--GO
INSERT INTO [dbo].[FAPayment_Leveraged_Lookup]
SELECT ID ,[DWUI_Interaction_ID__c] as LegacyID
FROM FA_Payment__c_Leveraged_2_Load_Result
where Error = 'Operation Successful.'
