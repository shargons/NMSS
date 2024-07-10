SELECT A.ID,B.Award_Amount__c
INTO FA_Request__c_Update
FROM FA_Request__c A
INNER JOIN [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFARequest] B
ON A.DWUI_Interaction_ID__c = B.DWUI_Interaction_ID__c
WHERE A.Award_Amount__c IS NULL

SELECT * FROM 
FA_Request__c_Update

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','FA_Request__c_Update'


SELECT B.ID,'FA Maintenance' as Status
INTO Case_Status_Update_2
FROM FA_Request__c A
INNER JOIN
[Case] B ON A.Case__c = B.ID
WHERE Status__c = 'Active FA Payments'
AND B.Status = 'Closed'

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Case_Status_Update_2'

SELECT * FROM Case_Status_Update_2_Result WHERE Error <> 'Operation Successful.'