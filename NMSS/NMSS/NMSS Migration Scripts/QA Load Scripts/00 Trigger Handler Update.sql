
DROP TABLE npsp__Trigger_Handler__c_Update

SELECT ID,'sharon.gonsalves@nmss.org.cfgqa' AS npsp__Usernames_to_Exclude__c
INTO npsp__Trigger_Handler__c_Update
FROM npsp__Trigger_Handler__c


EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','npsp__Trigger_Handler__c_Update'

SELECT * FROM npsp__Trigger_Handler__c_Update_Result