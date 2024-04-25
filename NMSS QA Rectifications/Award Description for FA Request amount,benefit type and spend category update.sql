
-- Direct FA Request Update
SELECT A.ID,B.Award_Description__c 
INTO FA_Request__c_Direct_Description_Update
FROM FA_Request__c_Direct_Load_Result A
INNER JOIN NMSS_SRC.CFG_NMSS_QA.[dbo].[vw_DW_CFG_DirectFARequest]   B
ON A.DWUI_Interaction_ID__c = B.DWUI_Interaction_ID__c

select * from FA_Request__c_Leveraged_Load_Result


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','FA_Request__c_Direct_Description_Update'

-- Leveraged FA Request Update
SELECT A.ID,B.Award_Description__c 
INTO FA_Request__c_Leveraged_Description_Update
FROM FA_Request__c_Leveraged_Load_Result A
INNER JOIN NMSS_SRC.CFG_NMSS_QA.[dbo].[vw_DW_CFG_LeveragedFARequest] B
ON A.DWUI_Interaction_ID__c = B.DWUI_Interaction_ID__c

select * from FA_Request__c_Direct_Description_Update

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','FA_Request__c_Leveraged_Description_Update'
