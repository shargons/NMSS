EXEC SF_Replicate 'CFG_NMSS_PROD','Contact','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','npe5__Affiliation__c','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','npe4__Relationship__c','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','Recordtype','pkchunk,batchsize(50000)',1

EXEC SF_Replicate 'CFG_NMSS_PROD','Case','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','Interest__c','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','CaseTeamMember','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','CaseTeamRole'

EXEC SF_Replicate 'CFG_NMSS_PROD','FA_Request__c','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','Warning__c','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','Profile','pkchunk,batchsize(50000)',1

EXEC SF_Replicate 'CFG_NMSS_PROD','UserRole','pkchunk,batchsize(50000)',1

EXEC SF_Replicate 'CFG_NMSS_PROD','User','pkchunk,batchsize(50000)',1

EXEC SF_Replicate 'CFG_NMSS_PROD','ContentVersion','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','ContentDocument','pkchunk,batchsize(50000)'

EXEC SF_Replicate 'CFG_NMSS_PROD','Consent_for_Release_of_Information__c','pkchunk,batchsize(50000)'