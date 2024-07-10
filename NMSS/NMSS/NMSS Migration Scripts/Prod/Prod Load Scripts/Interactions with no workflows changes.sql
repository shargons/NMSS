
--DROP TABLE [Case_Update]
SELECT *
INTO [CFG_NMSS_PROD].[dbo].[Case_Update]
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[Case_Update]

EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Case_Update'


SELECT IC.Id
into InterestedCase__c_Delete
FROM Interaction_Changes C
INNER JOIN [CFG_NMSS_PROD].[dbo].[Case] CL
ON C.InteractionId = CL.Data_Warehouse_ID__c
INNER JOIN InterestedCase__c IC
ON CL.Id = IC.Case__c
INNER JOIN Interest__c I
ON IC.Interest__c = I.Id
WHERE I.Name IN ('Benefits and Employment','Case Management')

EXEC SF_TableLoader 'Delete:BULKAPI2','CFG_NMSS_PROD','InterestedCase__c_Delete'


SELECT IC.Id
into InterestedCase__c_Delete_2
FROM Interaction_Changes C
INNER JOIN [CFG_NMSS_PROD].[dbo].[Case] CL
ON C.InteractionId = CL.Data_Warehouse_ID__c
INNER JOIN InterestedCase__c IC
ON CL.Id = IC.Case__c
INNER JOIN Interest__c I
ON IC.Interest__c = I.Id
WHERE I.Name IN ('Financial Assistance')

EXEC SF_TableLoader 'Delete:BULKAPI2','CFG_NMSS_PROD','InterestedCase__c_Delete_2'
