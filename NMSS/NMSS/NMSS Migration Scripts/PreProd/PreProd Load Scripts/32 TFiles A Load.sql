
---- ROI Files
--DROP TABLE [CFG_NMSS_PREPROD].[dbo].[ROIFilesA]
SELECT *, SUBSTRING(FilePath,PATINDEX('%[0-9]%',FilePath),8) as ConstituentId
  INTO [CFG_NMSS_PREPROD].[dbo].[ROIFilesA]
  FROM [CFG_NMSS_QA].[dbo].[TFilesA]
  WHERE Filename like '%ROI%'

---- Case Files
-- DROP TABLE [CFG_NMSS_PREPROD].[dbo].[CaseFilesA]
  SELECT *,SUBSTRING(FilePath,PATINDEX('%[0-9]%',FilePath),8) as ConstituentId
  INTO [CFG_NMSS_PREPROD].[dbo].[CaseFilesA]
  FROM [CFG_NMSS_QA].[dbo].[TFilesA]
  WHERE Filename NOT like '%ROI%'

-- Create ROI records for Constituents in SF
--DROP TABLE Consent_for_Release_of_Information__c_TFilesA_Insert
 SELECT DISTINCT 
 NULL AS Id
 ,ConstituentId as Source_Constituent__c
 ,C.SFID AS Constituent__c
 ,'ROI'+ConstituentId as Legacy_ID__c
 INTO Consent_for_Release_of_Information__c_TFilesA_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[ROIFilesA] A
 INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID


 -- Create Case records for Constituents in SF
--DROP TABLE Case_TFileA_Insert
 SELECT DISTINCT 
 NULL AS Id
 ,ConstituentId as Source_ContactId
 ,'CaseFile'+ConstituentId as Data_WarehouseID__c
 ,'Historical Files' as Subject
 ,'Case created to hold T Drive Case Files' as Description
 , C.SFID AS ContactId
 INTO [CFG_NMSS_PREPROD].[dbo].Case_TFileA_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[CaseFilesA] A
  INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID

 --====================================================================
--INSERTING DATA USING DBAMP - Consent_for_Release_of_Information__c
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Consent_for_Release_of_Information__c_TFilesA_Insert
ALTER COLUMN ID NVARCHAR(18)


SELECT * FROM Consent_for_Release_of_Information__c_TFilesA_Insert

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_TFilesA_Insert'

SELECT * FROM Consent_for_Release_of_Information__c_TFilesA_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Consent_for_Release_of_Information__c_TFilesA_Insert_Result GROUP BY Error

 --====================================================================
-- Create Lookup Table
--====================================================================

SELECT Id,Legacy_ID__c
INTO ROI_TFilesA_Lookup
FROM Consent_for_Release_of_Information__c_TFilesA_Insert_Result

 --====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_TFileA_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','Case_TFileA_Insert'

SELECT * FROM Case_TFileA_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Case_TFileA_Insert_Result GROUP BY Error

 --====================================================================
-- Create Lookup Table
--====================================================================

SELECT Id,Data_WarehouseID__c
INTO Case_TFilesA_Lookup
FROM Case_TFileA_Insert_Result

 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion ROI
--====================================================================
--DROP TABLE ContentVersion_ROI_A_Insert


SELECT 
  NULL AS ID
 ,'ROI'+ConstituentId as Legacy_ID__c
 ,FilePath AS PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,FileContentBinary AS VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Consent_for_Release_of_Information__c_TFilesA_Insert
 INTO ContentVersion_ROI_A_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[ROIFilesA] A
  INNER JOIN ROI_TFilesA_Lookup B
 ON 'ROI'+ConstituentId = B.Legacy_ID__c
 --WHERE ConstituentId='40181872'

 SELECT * FROM ContentVersion_ROI_A_Insert

  --====================================================================
--INSERTING DATA USING DBAMP - ROI
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_ROI_A_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PREPROD','ContentVersion_ROI_A_Insert'

SELECT * FROM ContentVersion_ROI_A_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error fromContentVersion_ROI_A_Insert_TEST_Result GROUP BY Error

/******* DBAmp Delete Script *********/
DROP TABLE ContentVersion_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'ContentVersion_DELETE'

INSERT INTO ContentVersion_DELETE(Id) SELECT Id FROM ContentVersion_ROI_A_Insert_TEST_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'ContentVersion_DELETE'


 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion Case Files
--====================================================================

 -- Case Files 

SELECT 
  NULL AS ID
 ,'CaseFile'+ConstituentId as Legacy_ID__c
 ,FilePath AS PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,FileContentBinary as VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Case_TFilesA_Insert
 INTO ContentVersion_CaseFile_A_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[CaseFilesA] A
  JOIN Case_TFilesA_Lookup B
 ON 'CaseFile'+ConstituentId = B.Data_WarehouseID__c

 --====================================================================
--INSERTING DATA USING DBAMP - ContentVersion
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_CaseFile_A_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PREPROD','ContentVersion_CaseFile_A_Insert'

SELECT * FROM ContentVersion_CaseFile_A_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Contentversion_A_Insert_Result GROUP BY Error