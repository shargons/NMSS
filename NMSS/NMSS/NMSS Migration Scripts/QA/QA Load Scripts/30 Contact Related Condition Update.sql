
USE CFG_NMSS_QA;

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Contact_RelatedCondition_Update];
--GO
SELECT HL.SFID AS ID,C.ClassificationValue AS Related_Condition_c__c
INTO [CFG_NMSS_QA].dbo.Contact_RelatedCondition_Update
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_Contact_RelatedCondition] C
LEFT JOIN [CFG_NMSS_QA].dbo.[XREF_Contact] HL
ON C.EntityId = HL.DWID
WHERE HL.SFID IS NOT NULL

SELECT * FROM Contact_RelatedCondition_Update


EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Contact_RelatedCondition_Update'