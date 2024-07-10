SELECT TOP (1000) [ConstituentId]
      ,[SurvivingID ]
  FROM [CFG_NMSS_PROD].[dbo].[CaseFile_Mismatch]


  UPDATE A
  SET A.CONSTITUENTID = B.[SurvivingID ]
  FROM [CFG_NMSS_PROD].[dbo].[T_CaseFiles] A
  INNER JOIN 
  [CFG_NMSS_PROD].[dbo].[CaseFile_Mismatch] B
  ON A.[ConstituentId] = B.[ConstituentId]


  --DROP TABLE Case_TFile_Insert
 SELECT DISTINCT 
 NULL AS Id
 ,ConstituentId as Source_ContactId
 ,'CaseFile'+ConstituentId as Data_WarehouseID__c
 ,'Historical Files' as Subject
 ,'Case created to hold T Drive Case Files' as Description
 , C.SFID AS ContactId
 ,R.Id as RecordTypeId
 ,'Closed' AS Status
 INTO [CFG_NMSS_PROD].[dbo].Case_TFile_Insert_2
 FROM [CFG_NMSS_PROD].[dbo].[T_CaseFiles] A
  LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID
 LEFT JOIN [CFG_NMSS_PROD].dbo.RecordType R
 ON R.DeveloperName = 'Navigator_Support_Request'
 WHERE A.ConstituentId IN (SELECT [SurvivingID ] FROM [CFG_NMSS_PROD].[dbo].[CaseFile_Mismatch])


 /******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_TFile_Insert_2
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Case_TFile_Insert_2

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_TFile_Insert_2'

SELECT * FROM Case_TFile_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Case_TFile_Insert_2_Result GROUP BY Error

 --====================================================================
-- Create Lookup Table
--====================================================================

SELECT Id,Data_WarehouseID__c
INTO Case_TFiles_Lookup_2
FROM Case_TFile_Insert_2_Result
WHERE Error = 'Operation Successful.'

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
 INTO ContentVersion_CaseFile_Insert_2
 FROM [CFG_NMSS_PROD].[dbo].[T_CaseFiles] A
  JOIN Case_TFiles_Lookup_2 B
 ON 'CaseFile'+ConstituentId = B.Data_WarehouseID__c
 ORDER BY FilePath

 --====================================================================
--INSERTING DATA USING DBAMP - ContentVersion
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_CaseFile_Insert_2
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM ContentVersion_CaseFile_Insert_2

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PROD','ContentVersion_CaseFile_Insert_2'

SELECT * FROM ContentVersion_CaseFile_Insert_2_Result where Error <> 'Operation Successful.'
AND Error like '%Required%'

select count(*), Error from Contentversion_Insert_Result GROUP BY Error



