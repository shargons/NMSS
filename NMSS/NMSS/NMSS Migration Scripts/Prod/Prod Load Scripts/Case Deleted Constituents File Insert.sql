SELECT * 
--INTO Case_TFile_Insert_Deleted
FROM Case_TFile_Insert_Result where Error <> 'Operation Successful.'


UPDATE A
SET A.Source_ContactId = B.SurvivingId
FROM Case_TFile_Insert_Deleted A
INNER JOIN 
[dbo].[Case_Deleted_Constituents] B
ON A.Source_ContactId = B.ConstituentId



UPDATE A
SET A.ConstituentId = B.SurvivingId
FROM [CFG_NMSS_PROD].[dbo].[T_CaseFiles] A
INNER JOIN 
[dbo].[Case_Deleted_Constituents] B
ON A.ConstituentId = B.ConstituentId


UPDATE A
SET A.ContactId = C.SFID
FROM Case_TFile_Insert_Deleted A
 LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.Source_ContactId = C.DWID
WHERE C.SFID IS NOT NULL

SELECT * 
FROM Case_TFile_Insert_Deleted

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_TFile_Insert_Deleted'

DROP TABLE CaseFiles_Deleted_Lookup
SELECT Id,Data_WarehouseID__c
INTO CaseFiles_Deleted_Lookup
FROM Case_TFile_Insert_Deleted_Result
where Id is not null

UPDATE A
SET A.Data_WarehouseID__c = 'CaseFile'+B.SurvivingId
FROM Case_TFile_Insert_Deleted_Result A
INNER JOIN 
[dbo].[Case_Deleted_Constituents] B
ON A.Source_ContactId = B.SurvivingId



--====================================================================
--PREPARE DATA TO INSERT - ContentVersion Case Files
--====================================================================

 -- Case Files 
 DROP TABLE ContentVersion_CaseFile_Insert

SELECT 
  NULL AS ID
 ,'CaseFile'+ConstituentId as Legacy_ID__c
 ,FilePath AS PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,FilePath AS VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Case_TFilesA_Insert
 INTO ContentVersion_CaseFile_Del_Constit_Insert
 FROM [CFG_NMSS_PROD].[dbo].[T_CaseFiles] A
  JOIN CaseFiles_Deleted_Lookup B
 ON 'CaseFile'+ConstituentId = B.Data_WarehouseID__c
 ORDER BY FilePath

 --====================================================================
--INSERTING DATA USING DBAMP - ContentVersion
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_CaseFile_Del_Constit_Insert
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM ContentVersion_CaseFile_Del_Constit_Insert_Result
WHERE Error <> 'Operation Successful.'

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PROD','ContentVersion_CaseFile_Del_Constit_Insert'

