USE CFG_NMSS_QA;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FA Request
--====================================================================


--DROP table FA_Request__c_Direct_Load
SELECT F.ID
	  ,[DWUI_Interaction_ID__c]
      ,[DWUI_Interaction_Detail_ID__c]
      ,[DWUI_Constituent_Key_Process_ID__c]
      ,[Source_Beneficiary_Contact__c]
	  ,C2.SFID AS Beneficiary_Contact__c
      ,F.[CreatedDate]
      ,[Source_CaseID]
	  ,C.ID AS Case__c
      ,[Decision_Date__c]
      ,[Status__c]
      ,[Requested_Amount__c]
      ,[Award_Amount__c]
      ,[Award_Type__c]
      ,[Award_Description__c]
      ,[Benefit_Type__c]
      ,[Spend_Category__c]
      ,F.[OwnerId]
      ,F.[CreatedById]
  INTO FA_Request__c_Direct_Load
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFARequest] F
	   INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Case] C 
	   ON C.Data_Warehouse_ID__c = F.[Source_CaseID]
	   INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C2
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
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FA_Request__c_Direct_Load'

SELECT * FROM FA_Request__c_Direct_Load_Result where Error ='Operation Successful.'

select DISTINCT Error from FA_Request__c_Direct_Load_Result

--====================================================================
--ERROR RESOLUTION - FA Request
--=====================================================

SELECT A.* 
INTO FA_Request__c_Direct_Load_2
FROM FA_Request__c_Direct_Load A
LEFT JOIN FA_Request__c B
ON A.[DWUI_Interaction_ID__c] = B.[DWUI_Interaction_ID__c]
WHERE B.ID IS NULL

SELECT distinct Benefit_Type__c,Error FROM FA_Request__c_Direct_Load_2_Result

Update FA_Request__c_Direct_Load_2
SET Benefit_Type__c = 'Walk Aide (such as Bioness)'
WHERE Benefit_Type__c = 'Walk Aide'

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
INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_FARequest]
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
FROM FA_Request__c_Direct_Load_2_Result
where Error = 'Operation Successful.'


DROP TABLE IF EXISTS [dbo].[FARequest_Lookup];
GO

INSERT INTO [dbo].[FARequest_Lookup]
SELECT ID ,[DWUI_Interaction_ID__c] as LegacyID
FROM FA_Request__c_Direct_Load_2_Result
where Error = 'Operation Successful.'
