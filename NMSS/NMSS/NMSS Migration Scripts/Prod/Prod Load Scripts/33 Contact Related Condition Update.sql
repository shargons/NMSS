
USE CFG_NMSS_PROD;

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Contact_RelatedCondition_Update];
--GO
SELECT HL.SFID AS ID,Related_Conditions__c
INTO [CFG_NMSS_PROD].dbo.Contact_RelatedCondition_Update
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_Contact_RelatedCondition] C
LEFT JOIN [NMSS_PRD].[SFINTEGRATION].dbo.[XREF_Contact] HL
ON C.EntityId = HL.DWID
WHERE HL.SFID IS NOT NULL

SELECT DISTINCT Related_Conditions__c FROM [CFG_NMSS_PROD].dbo.Contact_RelatedCondition_Update

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Contact_RelatedCondition_Update
ALTER COLUMN ID NVARCHAR(18)


EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PROD','Contact_RelatedCondition_Update'

SELECT * 
INTO  Contact_RelatedCondition_Update_2
FROM Contact_RelatedCondition_Update_Result
WHERE Error <> 'Operation Successful.'