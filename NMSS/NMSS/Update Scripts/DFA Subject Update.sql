SELECT B.ID, 'DFA' AS Subject
INTO Case_DFA_Update
FROM NMSS_SRC.[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FACases] A
INNER JOIN
[Case] B
ON A.[Data_Warehouse_ID__c] = B.Data_Warehouse_ID__c

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Case_DFA_Update'