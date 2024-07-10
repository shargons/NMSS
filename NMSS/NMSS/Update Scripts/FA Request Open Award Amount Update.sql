SELECT F1.ID,F.Award_Amount__c
INTO FA_Request__c_AwardAmount_Update
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_DirectFARequest] F
INNER JOIN [FA_Request__c] F1
ON F.[DWUI_Interaction_ID__c] = F1.DWUI_Interaction_ID__c
LEFT JOIN 
NMSS_SRC.TOMMIQA1.dbo.apfx_ConstituentKeyProcess cp
on cp.InteractionId = F.[DWUI_Interaction_ID__c]
WHERE F.Award_Amount__c <> F1.Award_Amount__c
and cp.completeFlag = 0


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','FA_Request__c_AwardAmount_Update'