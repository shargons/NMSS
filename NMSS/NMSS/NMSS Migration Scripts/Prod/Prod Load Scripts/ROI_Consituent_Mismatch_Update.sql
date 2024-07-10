SELECT * FROM ROI_Mismatch


SELECT *
--INTO Consent_for_Release_of_Information__c_TFiles_Insert_Missing_Constituents
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Result
where Constituent__c is null

UPDATE A
SET A.Source_Constituent__c = B.[Surviving Id] 
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Missing_Constituents A
INNER JOIN 
ROI_Mismatch B
ON A.Source_Constituent__c = B.ConstituentId

SELECT A.ID,C.SFID AS Constituent__c
--INTO  Consent_for_Release_of_Information__c_Constituent_Update
FROM Consent_for_Release_of_Information__c_TFiles_Insert_Missing_Constituents A
 LEFT JOIN [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact] C
 ON A.Source_Constituent__c = C.DWID
WHERE C.SFID IS NOT NULL

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Consent_for_Release_of_Information__c_Constituent_Update'
