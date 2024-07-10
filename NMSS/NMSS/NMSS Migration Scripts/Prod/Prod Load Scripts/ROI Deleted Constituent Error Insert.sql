SELECT * FROM [dbo].[ROI_Deleted_Constituents]

SELECT * 
--INTO Consent_for_Release_of_Information__c_Deleted_Constituents
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result where Error <> 'Operation Successful.'

UPDATE A
SET A.Source_Constituent__c = B.SurvivingId
FROM Consent_for_Release_of_Information__c_Deleted_Constituents A
INNER JOIN 
[dbo].[ROI_Deleted_Constituents] B
ON A.Source_Constituent__c = B.ConstituentId

UPDATE A
SET A.Constituent__c = C.SFID
--INTO  Consent_for_Release_of_Information__c_Constituent_Update
FROM Consent_for_Release_of_Information__c_Deleted_Constituents A
 LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.Source_Constituent__c = C.DWID
WHERE C.SFID IS NOT NULL

select * 
into Consent_for_Release_of_Information__c_Deleted_Constituents_Insert
from Consent_for_Release_of_Information__c_Deleted_Constituents

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_Deleted_Constituents_Insert'

SELECT Id,Legacy_Id__c
INTO COI_Deleted_Lookup
FROM Consent_for_Release_of_Information__c_Deleted_Constituents_Insert_Result
where Id is not null


 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion ROI
--====================================================================

SELECT
  NULL AS ID
 ,LEFT(FileName,80) as Legacy_ID__c
 ,FilePath AS PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,FilePath AS VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Consent_for_Release_of_Information__c_TFilesA_Insert
 INTO ContentVersion_ROI_Deleted_Insert
 FROM [CFG_NMSS_PROD].[dbo].[T_ROIFiles] A
  INNER JOIN COI_Deleted_Lookup B
 ON FileName = B.Legacy_ID__c
 ORDER BY FilePath


  --====================================================================
--INSERTING DATA USING DBAMP - ROI
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_ROI_Deleted_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PROD','ContentVersion_ROI_Deleted_Insert'

SELECT * FROM ContentVersion_ROI_Insert_Result where Error <> 'Operation Successful.'
AND Error not Like '%Required%'

select count(*), Error fromContentVersion_ROI_Insert_Result GROUP BY Error