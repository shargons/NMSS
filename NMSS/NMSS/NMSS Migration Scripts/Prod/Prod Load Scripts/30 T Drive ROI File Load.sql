 
/**************** Create ROI table *****************/
SELECT Filename,Folder+'\'+Filename as FilePath,SUBSTRING(Folder,PATINDEX('%[0-9]%',Folder),8) as ConstituentId
--INTO CFG_NMSS_PROD.dbo.T_ROIFiles
FROM CFG_NMSS_PROD.dbo.DFileSize
WHERE CAST([Filesize in MB] AS DECIMAL) < 40
AND FileName like '%ROI%'
ORDER BY FilePath
 -- 21935

 /**************** Create Records for ROI with Contact Lookup ****************/
 DROP TABLE Consent_for_Release_of_Information__c_TFiles_Insert
 SELECT  
 NULL AS Id
 ,ConstituentId as Source_Constituent__c
 ,C.SFID AS Constituent__c
 ,Filename as Legacy_ID__c
 ,FileName as Description_of_How_the_Info_Will_Be_Used__c
INTO Consent_for_Release_of_Information__c_TFiles_Insert
 FROM [CFG_NMSS_PROD].[dbo].[T_ROIFiles] A
 LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.ConstituentId = C.DWID

 --====================================================================
--INSERTING DATA USING DBAMP - Consent_for_Release_of_Information__c
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Consent_for_Release_of_Information__c_TFiles_Insert
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Consent_for_Release_of_Information__c_TFiles_Insert
where Constituent__c is null

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_TFiles_Insert'

SELECT * 
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result where Error <> 'Operation Successful.'

select count(*), Error from Consent_for_Release_of_Information__c_TFiles_Insert_Result GROUP BY Error

UPDATE A
SET A.Legacy_Id__c = B.Legacy_ID__c
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result A
INNER JOIN
Consent_for_Release_of_Information__c_TFiles_Insert B
ON A.Description_of_How_the_Info_Will_Be_Used__c = B.Description_of_How_the_Info_Will_Be_Used__c
AND A.Constituent__c = B.Constituent__c

 --====================================================================
-- Create Lookup Table
--====================================================================
--DROP TABLE ROI_TFiles_Lookup
SELECT Id,Legacy_ID__c
INTO ROI_TFiles_Lookup
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result
WHERE Error = 'Operation Successful.'

 --====================================================================
--PREPARE DATA TO INSERT - ContentVersion ROI
--====================================================================
DROP TABLE ContentVersion_ROI_Insert


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




  --====================================================================
--INSERTING DATA USING DBAMP - ROI
--====================================================================
/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE ContentVersion_ROI_Insert
ALTER COLUMN ID NVARCHAR(18)

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:soap,batchsize(1)','CFG_NMSS_PROD','ContentVersion_ROI_Insert'

SELECT * FROM ContentVersion_ROI_Insert_Result where Error <> 'Operation Successful.'
AND Error not Like '%Required%'

select count(*), Error fromContentVersion_ROI_Insert_Result GROUP BY Error

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




