select B.ID,A.Award_Amount__c
INTO FA_Request__c_Direct_Update
from [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFARequest] A
INNER JOIN
[dbo].[FA_Request__c_Direct_Load_Result] B
ON A.DWUI_Interaction_ID__c = B.DWUI_Interaction_ID__c
WHERE A.Award_Amount__c <> B.Award_Amount__c

SELECT * FROM FA_Request__c_Direct_Update

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','FA_Request__c_Direct_Update'