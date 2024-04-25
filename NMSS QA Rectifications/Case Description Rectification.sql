SELECT A.Id,B.Subject
INTO Case_Subject_Update
FROM [Case] A
INNER JOIN
NMSS_SRC.CFG_NMSS_QA.dbo.[vw_DW_CFG_Case] B
ON A.Data_Warehouse_ID__c = B.Data_Warehouse_ID__c

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Case_Subject_Update'
