SELECT ID,'LiteratureType'+CAST(LegacyID__c AS NVARCHAR) AS LegacyID__c
INTO InterestedCase__c_LT_UPDATE
FROM 
InterestedCase__c_LT_Load_Result A


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','InterestedCase__c_LT_UPDATE'




SELECT ID,'ResponseType'+CAST(LegacyID__c AS NVARCHAR) AS LegacyID__c
INTO InterestedCase__c_RT_UPDATE
FROM 
InterestedCase__c_Load_Result A


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','InterestedCase__c_RT_UPDATE'




SELECT ID,'TrackedTopic'+CAST(LegacyID__c AS NVARCHAR) AS LegacyID__c
INTO InterestedCase__c_TT_UPDATE
FROM 
InterestedCase__c_TT_Load_Result A


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','InterestedCase__c_TT_UPDATE'