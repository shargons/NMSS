
--- Expiry Date
--DROP TABLE Consent_for_Release_of_Information__c_A_ExpiryDate_Update
SELECT x.FirstPublishLocationId AS ID,IIF(ISDATE(x.ExpiryDate)=1,CAST(x.ExpiryDate AS date) ,NULL) AS Expiration_Date__c
INTO Consent_for_Release_of_Information__c_B_ExpiryDate_Update
FROM 
(
SELECT Title,FirstPublishLocationId,
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+4,4))=4,SUBSTRING(Title,PATINDEX('%EXP%',Title)+4,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2))=2,SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+12,2))=2 AND SUBSTRING(Title,PATINDEX('%EXP%',Title)+12,2) like '%[0-9]%',SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2),'01') AS ExpiryDate
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
where Title LIKE '%exp%'
)x

EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_ExpiryDate_Update'

SELECT * FROM Consent_for_Release_of_Information__c_B_ExpiryDate_Update_Result
WHERE Error <> 'Operation Successful.'

--- FORMAT EXP YYYY MM
SELECT x.FirstPublishLocationId AS ID,IIF(ISDATE(x.ExpiryDate)=1,CAST(x.ExpiryDate AS date) ,NULL) AS Expiration_Date__c
INTO Consent_for_Release_of_Information__c_B_ExpiryDate_Update_2
FROM 
(
SELECT Title,FirstPublishLocationId,
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+4,4))=4,SUBSTRING(Title,PATINDEX('%EXP%',Title)+4,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2))=2,SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%EXP%',Title)+12,2))=2 AND SUBSTRING(Title,PATINDEX('%EXP%',Title)+12,2) like '%[0-9]%',SUBSTRING(Title,PATINDEX('%EXP%',Title)+9,2),'01') AS ExpiryDate
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
where (Title like '%exp% %[0-9]% %[0-9]% %[A-Z]%' AND Title NOT LIKE '%exp% %[0-9]% %[0-9]% %[0-9]%')
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_ExpiryDate_Update_2'



-- Sent Date
--DROP TABLE Consent_for_Release_of_Information__c_SentDate_Update
SELECT x.FirstPublishLocationId AS ID,IIF(ISDATE(x.SentDate)=1,CAST(x.SentDate AS date) ,NULL) AS Date_Sent__c
INTO Consent_for_Release_of_Information__c_B_SentDate_Update
FROM 
(
SELECT Title,FirstPublishLocationId,
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+5,4))=4,SUBSTRING(Title,PATINDEX('%sent%',Title)+5,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2))=2,SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+13,2))=2 AND SUBSTRING(Title,PATINDEX('%sent%',Title)+13,2) like '%[0-9]%',SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2),'01') AS SentDate
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
where Title LIKE '%sent %'
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_SentDate_Update'

SELECT x.FirstPublishLocationId AS ID,IIF(ISDATE(x.SentDate)=1,CAST(x.SentDate AS date) ,NULL) AS Date_Sent__c
INTO Consent_for_Release_of_Information__c_B_SentDate_Update_2
FROM 
(
SELECT Title,FirstPublishLocationId,
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+5,4))=4,SUBSTRING(Title,PATINDEX('%sent%',Title)+5,4),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2))=2,SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2),NULL) +'-'+
IIF(LEN(SUBSTRING(Title,PATINDEX('%sent%',Title)+13,2))=2 AND SUBSTRING(Title,PATINDEX('%sent%',Title)+13,2) like '%[0-9]%',SUBSTRING(Title,PATINDEX('%sent%',Title)+10,2),'01') AS SentDate
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
where Title like '%sent% %[0-9]% %[0-9]% %[A-Z]%' AND Title NOT LIKE '%sent% %[0-9]% %[0-9]% %[0-9]%'
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_SentDate_Update_2'

SELECT * FROM Consent_for_Release_of_Information__c_B_SentDate_Update_2_Result
WHERE Error <> 'Operation Successful.'

-- Status
--DROP TABLE Consent_for_Release_of_Information__c_B_Status_Update
SELECT x.FirstPublishLocationId AS ID,Status__c
INTO Consent_for_Release_of_Information__c_B_Status_Update
FROM 
(
SELECT Title,FirstPublishLocationId,
CASE
WHEN Title LIKE '%Unsigned%' THEN 'Waiting for Response'
WHEN Title LIKE '%Signed%' THEN 'Complete'
WHEN Title LIKE '%Revoked%' THEN 'Revoked'
ELSE 'Waiting for Response'
END AS Status__c
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_Status_Update'

-- Filename in Description
--DROP TABLE Consent_for_Release_of_Information__c_Desc_Update
SELECT x.FirstPublishLocationId AS ID,Description_of_How_the_Info_Will_Be_Used__c
INTO Consent_for_Release_of_Information__c_B_Desc_Update
FROM 
(
SELECT Title,FirstPublishLocationId,
Title AS Description_of_How_the_Info_Will_Be_Used__c
FROM [CFG_NMSS_PREPROD].[dbo].[ContentVersion_ROI_B_Insert_Result]
)x

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Consent_for_Release_of_Information__c_B_Desc_Update'


SELECT * FROM Consent_for_Release_of_Information__c_B_Desc_Update_Result
WHERE Error <> 'Operation Successful.'