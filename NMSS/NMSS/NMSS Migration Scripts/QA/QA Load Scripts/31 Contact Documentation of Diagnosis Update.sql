--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Contact_DocDiagnosisDate_Update];
--GO
SELECT HL.SFID AS ID,C.Documentation_of_Diagnosis_Date__c
--INTO [CFG_NMSS_QA].dbo.Contact_DocDiagnosisDate_Update
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_Contact_DocDiagnosisDate] C
LEFT JOIN [CFG_NMSS_QA].dbo.[XREF_Contact] HL
ON C.EntityId = HL.DWID
WHERE HL.SFID IS NOT NULL


EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Contact_DocDiagnosisDate_Update'