
--DROP TABLE T_ROIFiles
SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
--INTO CFG_NMSS_PREPROD.dbo.T_ROIFiles
FROM CFG_NMSS_QA.dbo.TDriveFiles
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName like '%ROI%'

--DROP TABLE T_CaseFiles
SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
INTO CFG_NMSS_PREPROD.dbo.T_CaseFiles
FROM CFG_NMSS_QA.dbo.TDriveFiles
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName not like '%ROI%'

-- Create ROI records for Constituents in SF

--DROP TABLE Consent_for_Release_of_Information__c_TFiles_Insert
 SELECT  
 NULL AS Id
 ,ConstituentId as Source_Constituent__c
 ,C.SFID AS Constituent__c
 ,LEFT(Filename,80) as Legacy_ID__c
 ,FileName as Description_of_How_the_Info_Will_Be_Used__c
INTO Consent_for_Release_of_Information__c_TFiles_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[T_ROIFiles] A
 INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID




 --====================================================================
--INSERTING DATA USING DBAMP - Consent_for_Release_of_Information__c
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Consent_for_Release_of_Information__c_TFiles_Insert
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Consent_for_Release_of_Information__c_TFiles_Insert

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_TFiles_Insert'

SELECT * 
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Consent_for_Release_of_Information__c_TFilesA_Insert_Result GROUP BY Error

 --====================================================================
-- Create Lookup Table
--====================================================================
DROP TABLE ROI_TFiles_Lookup
SELECT Id,Legacy_ID__c
INTO ROI_TFiles_Lookup
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result


 --====================================================================
--INSERTING DATA USING DBAMP - Case
--====================================================================

 -- Create Case records for Constituents in SF
DROP TABLE Case_TFile_Insert
 SELECT DISTINCT 
 NULL AS Id
 ,ConstituentId as Source_ContactId
 ,'CaseFile'+ConstituentId as Data_WarehouseID__c
 ,'Historical Files' as Subject
 ,'Case created to hold T Drive Case Files' as Description
 , C.SFID AS ContactId
 --,R.Id as RecordTypeId
 INTO [CFG_NMSS_PREPROD].[dbo].Case_TFile_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[T_CaseFiles] A
  INNER JOIN [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID
 --LEFT JOIN [CFG_NMSS_PREPROD].dbo.RecordType R
 --ON R.DeveloperName = 'Navigator_Case'

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_TFile_Insert
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Case_TFile_Insert

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','Case_TFile_Insert'

SELECT * FROM Case_TFile_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Case_TFile_Insert_Result GROUP BY Error

 --====================================================================
-- Create Lookup Table
--====================================================================

SELECT Id,Data_WarehouseID__c
INTO Case_TFiles_Lookup
FROM Case_TFile_Insert_Result

 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion ROI
--====================================================================
DROP TABLE ContentVersion_ROI_M_Insert


SELECT 
  NULL AS ID
 ,LEFT(FileName,80) as Legacy_ID__c
 ,REPLACE(FilePath,'Y:','‪C:') AS PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,REPLACE(FilePath,'Y:','‪C:') as VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Consent_for_Release_of_Information__c_TFilesA_Insert
 INTO ContentVersion_ROI_M_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[T_ROIFiles] A
  INNER JOIN ROI_TFiles_Lookup B
 ON LEFT(FileName,80) = B.Legacy_ID__c
 WHERE FilePath LIKE '%\M\%'

 SELECT * FROM ContentVersion_ROI_M_Insert
  where FirstPublishLocationId IS NULL

UPDATE A
SET A.PathOnClient = REPLACE(PathOnClient,'?','')
FROM ContentVersion_ROI_M_Insert A

UPDATE A
SET A.VersionData = REPLACE(VersionData,'?','')
FROM ContentVersion_ROI_M_Insert A



  --====================================================================
--INSERTING DATA USING DBAMP - ROI
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_ROI_M_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PREPROD','ContentVersion_ROI_M_Insert'

SELECT *
--INTO ContentVersion_ROI_F_Insert_2
FROM ContentVersion_ROI_M_Insert_Result 
where Error <> 'Operation Successful.'


select count(*), Error from ContentVersion_ROI_M_Insert_Result GROUP BY Error

/******* DBAmp Delete Script *********/
DROP TABLE ContentVersion_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'ContentVersion_DELETE'

INSERT INTO ContentVersion_DELETE(Id) SELECT Id FROM ContentVersion_ROI_M_Insert_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'ContentVersion_DELETE'


 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion Case Files
--====================================================================

 -- Case Files 
 DROP TABLE ContentVersion_CaseFile_M_Insert

SELECT
  NULL AS ID
 ,'CaseFile'+ConstituentId as Legacy_ID__c
 ,REPLACE(FilePath,'Y:','C:') AS PathOnClient
 --,FilePath as PathOnClient
 ,1 as IsMajorVersion
 ,FileName as Title
 ,'P' as PublishStatus
 ,'N' as SharingPrivacy
 ,REPLACE(FilePath,'Y:','C:') AS VersionData
 --,FilePath as VersionData
 ,B.ID AS FirstPublishLocationId -- Get id from Case_TFilesA_Insert
 INTO ContentVersion_CaseFile_M_Insert
 FROM [CFG_NMSS_PREPROD].[dbo].[T_CaseFiles] A
  JOIN Case_TFiles_Lookup B
 ON 'CaseFile'+ConstituentId = B.Data_WarehouseID__c
  WHERE FilePath LIKE '%\M\%'

 --====================================================================
--INSERTING DATA USING DBAMP - ContentVersion
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_CaseFile_M_Insert
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM ContentVersion_CaseFile_M_Insert
 where FirstPublishLocationId IS NULL

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PREPROD','ContentVersion_CaseFile_M_Insert'

SELECT * FROM ContentVersion_CaseFile_M_Insert_Result where Error <> 'Operation Successful.'

SELECT * FROM ContentVersion_CaseFile_M_Insert_Result where Error LIKE '%part%'

select count(*), Error from ContentVersion_CaseFile_M_Insert_Result GROUP BY Error