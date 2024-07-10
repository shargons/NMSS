--DROP TABLE Case_BET_Owner_Update
SELECT B.ID,A.OwnerId
INTO Case_BET_Owner_Update
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_B&ECases] A
INNER JOIN [Case] B
ON A.Data_Warehouse_ID__c = B.Data_Warehouse_ID__c
WHERE A.OwnerId <> B.OwnerId


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Case_BET_Owner_Update'

SELECT * FROM Case_BET_Owner_Update_Result
WHERE Error <> 'Operation Successful.'


SELECT B.Data_Warehouse_ID__c,B.ID,A.OwnerId as [New OwnerId],B.OwnerId AS [Current OwnerId]
--INTO Case_FA_Owner_Update
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_FACases]  A
INNER JOIN [Case] B
ON A.Data_Warehouse_ID__c = B.Data_Warehouse_ID__c
WHERE A.OwnerId <> B.OwnerId

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Case_FA_Owner_Update'

SELECT * FROM Case_FA_Owner_Update_Result
WHERE Error <> 'Operation Successful.'

SELECT DISTINCT B.Data_Warehouse_ID__c,C.ID,C.OwnerId,B.OwnerId
--INTO Case_Owner_Update
FROM Case_Owner_Update_Result C
INNER JOIN [Case] B
ON B.ID = C.ID
WHERE C.Error <> 'Operation Successful.'
AND C.OwnerId <> '005f4000004cweYAAQ'

select * from Case_Owner_Update_Result
WHERE 

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Case_Owner_Update'