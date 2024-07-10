SELECT * FROM [CFG_NMSS_PROD].[dbo].Consent_for_Release_of_Information__c_TFiles_Insert
WHERE Legacy_Id__c like '%HCP ROI to The Multiple Sclerosis Clinic At The Neurology Center Of New England Authorized Exp 2024 11 28 Miller Cathy.pdf%'

 SELECT  
 NULL AS Id
 ,ConstituentId as Source_Constituent__c
 ,C.SFID AS Constituent__c
 ,LEFT(Filename,80) as Legacy_ID__c
 ,FileName as Description_of_How_the_Info_Will_Be_Used__c
 FROM [CFG_NMSS_PROD].[dbo].[T_ROIFiles] A
 LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID
 WHERE FileName like '%HCP ROI to The Multiple Sclerosis Clinic At The Neurology Center Of New England Authorized Exp 2024 11 28 Miller Cathy.pdf%'


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
 INTO ContentVersion_ROI_Insert
 FROM [CFG_NMSS_PROD].[dbo].[T_ROIFiles] A
  INNER JOIN ROI_TFiles_Lookup B
 ON LEFT(FileName,80) = B.Legacy_ID__c
 ORDER BY FilePath

 SELECT A.FirstPublishLocationId,B.Id
 FROM ContentVersion_ROI_Insert_Result A
 INNER JOIN
 [CFG_NMSS_PROD].[dbo].Consent_for_Release_of_Information__c_TFiles_Insert_Result B
 ON A.Title = B.Description_of_How_the_Info_Will_Be_Used__c
 WHERE A.FirstPublishLocationId <> B.Id

 SELECT Id,Description_of_How_the_Info_Will_Be_Used__c as Legacy_ID__c
INTO ROI_TFiles_Lookup
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result
WHERE Error = 'Operation Successful.'

SELECT A.ID,B.ID AS FirstPublishLocationId
INTO ContentVersion_Update
 FROM [CFG_NMSS_PROD].[dbo].[ContentVersion_ROI_Insert_Result] A
  INNER JOIN ROI_TFiles_Lookup B
 ON Title = B.Legacy_ID__c
 WHERE A.FirstPublishLocationId <> B.ID

 /******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','ContentVersion_Update'

SELECT * FROM ContentVersion_Update_Result
WHERE Error <> 'Operation Successful.'


SELECT ID,FirstPublishLocationId
--INTO ContentVersion_Delete
FROM
(
SELECT ID,FirstPublishLocationId,ROW_NUMBER() OVER (PARTITION BY Title,FirstPublishLocationId ORDER BY Title,FirstPublishLocationId)  AS rownum
FROM (
SELECT A.ID,B.ID AS FirstPublishLocationId,Title
 FROM [CFG_NMSS_PROD].[dbo].[ContentVersion_ROI_Insert_Result] A
  INNER JOIN ROI_TFiles_Lookup B
 ON Title = B.Legacy_ID__c
 WHERE A.FirstPublishLocationId <> B.ID
 )X
)Y
WHERE Y.rownum = 1 and 

 /******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Delete','CFG_NMSS_PROD','ContentVersion_Delete'

select * from ContentVersion_Delete_Result

/*************** Deleting the Consent for ROI records which have the same document ***************/


SELECT DISTINCT B2.ID ,x.id AS FirstPublishLocationId
INTO ContentVersion_Update_2
FROM 
(
SELECT A.ID,A.Description_of_How_the_Info_Will_Be_Used__c,B.FirstPublishLocationId
FROM Consent_for_Release_of_Information__c A
LEFT JOIN
ContentVersion B
ON A.ID = B.FirstPublishLocationId
WHERE B.FirstPublishLocationId IS NULL
)X
INNER JOIN ContentVersion_ROI_Insert_Result B2
 ON Description_of_How_the_Info_Will_Be_Used__c = B2.Title
 WHERE B2.ID IS NOT NULL


 /******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update','CFG_NMSS_PROD','ContentVersion_Update_2'

SELECT * FROM ContentVersion_Update_2_Result

