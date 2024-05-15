
--DROP TABLE Account_ServiceProvider_Update
SELECT  
AL.ID
,Service_Provider_ID__c
,ISNULL(Local_Provider__c,0) AS Local_Provider__c
,ISNULL(State_Provider__c,0) AS State_Provider__c
,ISNULL(National_Provider__c,0) AS National_Provider__c
,ISNULL(Remote_Service__c,0) AS Remote_Service__c
,Last_Review_Date__c
,Form_Complete_Date__c
,ISNULL(Needs_Updating__c,0) AS Needs_Updating__c
,Services_Offered__c
,Provider_Status_Comments__c
,Location_Name__c
,ISNULL(Service_Offered_At_Location__c,0) AS Service_Offered_At_Location__c
,Eligibility_Requirements__c
INTO Account_ServiceProvider_Update
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_CFG_Organization_Account] A
INNER JOIN
[dbo].[Account_Lookup] AL
ON A.Data_Warehouse_ID__c = AL.LegacyID
WHERE Service_Provider_ID__c IS NOT NULL

EXEC SF_TableLoader 'Update','CFG_NMSS_QA','Account_ServiceProvider_Update'

select * from Account_ServiceProvider_Update_Result where Error <> 'Operation Succcessful.'