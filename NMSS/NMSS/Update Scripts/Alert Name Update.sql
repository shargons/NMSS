SELECT ID,LEFT(Comment__c,80) as Name 
INTO Warning__c_Update
FROM Warning__c

EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PREPROD','Warning__c_Update_2'

SELECT * 
--INTO Warning__c_Update_2
FROM Warning__c_Update_Result 
WHERE Error = 'Operation Successful.'