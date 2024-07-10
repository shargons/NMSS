USE CFG_NMSS_PROD;

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Contact_DocDiagnosisDate_Update];
--GO
SELECT HL.SFID AS ID,C.Documentation_of_Diagnosis_Date__c
INTO [CFG_NMSS_PROD].dbo.Contact_DocDiagnosisDate_Update
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_Contact_DocDiagnosisDate] C
LEFT JOIN [NMSS_PRD].[SFINTEGRATION].dbo.[XREF_Contact] HL
ON C.EntityId = HL.DWID
WHERE HL.SFID IS NOT NULL

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Contact_DocDiagnosisDate_Update
ALTER COLUMN ID NVARCHAR(18)

EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Contact_DocDiagnosisDate_Update'

SELECT * FROM Contact_DocDiagnosisDate_Update_Result
WHERE Error <> 'Operation Successful.'