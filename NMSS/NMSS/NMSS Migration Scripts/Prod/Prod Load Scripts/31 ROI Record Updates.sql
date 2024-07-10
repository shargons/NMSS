
--- Expiry Date
--DROP TABLE Consent_for_Release_of_Information__c_ExpiryDate_Update
SELECT x.Id AS ID,IIF(ISDATE(x.ExpiryDate)=1,CAST(x.ExpiryDate AS date) ,NULL) AS Expiration_Date__c,NULL AS Date_Sent__c
INTO Consent_for_Release_of_Information__c_ExpiryDate_Update
FROM 
(
SELECT Description_of_How_the_Info_Will_Be_Used__c,Id,
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+4,4))=4,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+4,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+9,2))=2,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+9,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+12,2))=2 AND SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+12,2) like '%[0-9]%',SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+12,2),'01') AS ExpiryDate
FROM [CFG_NMSS_PROD].[dbo].[Consent_for_Release_of_Information__c_TFiles_Insert_Result]
where Description_of_How_the_Info_Will_Be_Used__c LIKE '%exp%' and Error = 'Operation Successful.'
)x

EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_ExpiryDate_Update'

SELECT * FROM Consent_for_Release_of_Information__c_ExpiryDate_Update_Result


--- FORMAT EXP YYYY MM
--drop table Consent_for_Release_of_Information__c_ExpiryDate_Update_2
SELECT x.Id AS ID,IIF(ISDATE(x.ExpiryDate)=1,CAST(x.ExpiryDate AS date) ,NULL) AS Expiration_Date__c,NULL AS Date_Sent__c
INTO Consent_for_Release_of_Information__c_ExpiryDate_Update_2
FROM 
(
SELECT Description_of_How_the_Info_Will_Be_Used__c,Id,
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+4,4))=4,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+4,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+9,2))=2,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+9,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+12,2))=2 AND SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+12,2) like '%[0-9]%',SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%EXP%',Description_of_How_the_Info_Will_Be_Used__c)+9,2),'01') AS ExpiryDate
FROM [CFG_NMSS_PROD].[dbo].[Consent_for_Release_of_Information__c_TFiles_Insert_Result]
where (Description_of_How_the_Info_Will_Be_Used__c like '%exp% %[0-9]% %[0-9]% %[A-Z]%' AND Description_of_How_the_Info_Will_Be_Used__c NOT LIKE '%exp% %[0-9]% %[0-9]% %[0-9]%')
and Error = 'Operation Successful.'
)x


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_ExpiryDate_Update_2'

SELECT * FROM Consent_for_Release_of_Information__c_ExpiryDate_Update_2_Result
WHERE Error <> 'Operation Successful.'

-- Sent Date
--DROP TABLE Consent_for_Release_of_Information__c_SentDate_Update
SELECT x.Id AS ID,IIF(ISDATE(x.SentDate)=1,CAST(x.SentDate AS date) ,NULL) AS Date_Sent__c,NULL AS Expiration_Date__c
INTO Consent_for_Release_of_Information__c_SentDate_Update
FROM 
(
SELECT Description_of_How_the_Info_Will_Be_Used__c,Id,
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+5,4))=4,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+5,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2))=2,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+13,2))=2 AND SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+13,2) like '%[0-9]%',SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2),'01') AS SentDate
FROM [CFG_NMSS_PROD].[dbo].[Consent_for_Release_of_Information__c_TFiles_Insert_Result]
where Description_of_How_the_Info_Will_Be_Used__c LIKE '%sent %' and Error = 'Operation Successful.'
)x


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_SentDate_Update'

--DROP TABLE Consent_for_Release_of_Information__c_SentDate_Update_2
SELECT x.Id AS ID,IIF(ISDATE(x.SentDate)=1,CAST(x.SentDate AS date) ,NULL) AS Date_Sent__c,NULL AS Expiration_Date__c
INTO Consent_for_Release_of_Information__c_SentDate_Update_2
FROM 
(
SELECT Description_of_How_the_Info_Will_Be_Used__c,Id,
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+5,4))=4,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+5,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2))=2,SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+13,2))=2 AND SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+13,2) like '%[0-9]%',SUBSTRING(Description_of_How_the_Info_Will_Be_Used__c,PATINDEX('%sent%',Description_of_How_the_Info_Will_Be_Used__c)+10,2),'01') AS SentDate
FROM [CFG_NMSS_PROD].[dbo].[Consent_for_Release_of_Information__c_TFiles_Insert_Result]
where Description_of_How_the_Info_Will_Be_Used__c like '%sent% %[0-9]% %[0-9]% %[A-Z]%' AND Description_of_How_the_Info_Will_Be_Used__c NOT LIKE '%sent% %[0-9]% %[0-9]% %[0-9]%'
and Error = 'Operation Successful.'
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_SentDate_Update_2'

SELECT * FROM Consent_for_Release_of_Information__c_SentDate_Update_2_Result
WHERE Error <> 'Operation Successful.'

-- Status
--DROP TABLE Consent_for_Release_of_Information__c_Status_Update
SELECT x.Id AS ID,Status__c
INTO Consent_for_Release_of_Information__c_Status_Update
FROM 
(
SELECT Description_of_How_the_Info_Will_Be_Used__c,Id,
CASE
WHEN Description_of_How_the_Info_Will_Be_Used__c LIKE '%Unsigned%' THEN 'Waiting for Response'
WHEN Description_of_How_the_Info_Will_Be_Used__c LIKE '%Signed%' THEN 'Complete'
WHEN Description_of_How_the_Info_Will_Be_Used__c LIKE '%Revoked%' THEN 'Revoked'
ELSE 'Complete'
END AS Status__c
FROM [CFG_NMSS_PROD].[dbo].[Consent_for_Release_of_Information__c_TFiles_Insert_Result]
WHERE Error = 'Operation Successful.'
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_Status_Update'

-- Filename in Description
--DROP TABLE Consent_for_Release_of_Information__c_Desc_Update
SELECT x.FirstPublishLocationId AS ID,Title as Description_of_How_the_Info_Will_Be_Used__c
INTO Consent_for_Release_of_Information__c_Desc_Update
FROM 
(
SELECT Title,FirstPublishLocationId,
Title AS Description_of_Information_To_Release__c
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_A_Insert_Result]
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_Desc_Update'


SELECT * FROM Consent_for_Release_of_Information__c_Desc_Update_Result
WHERE Error <> 'Operation Successful.'