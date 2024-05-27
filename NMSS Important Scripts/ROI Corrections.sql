
DROP TABLE Consent_for_Release_of_Information__c_Delete
SELECT ID
INTO Consent_for_Release_of_Information__c_Delete
FROM Consent_for_Release_of_Information__c_TFilesA_Insert_Result where Error = 'Operation Successful.'

EXEC SF_TableLoader 'HardDelete','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_Delete'

--DROP TABLE ContentVersion_Update
SELECT A.ID, B.ID AS FirstPublishLocationId
into ContentVersion_Update
FROM 
ContentVersion_ROI_A_Insert_Result A
INNER JOIN
ROI_TFilesA_Lookup B
ON LEFT(A.Title,80) = B.Legacy_ID__c



EXEC SF_TableLoader 'Update','CFG_NMSS_PREPROD','ContentVersion_Update'

SELECT * FROM ContentVersion_Update_Result WHERE Error <> 'Operation Successful.'