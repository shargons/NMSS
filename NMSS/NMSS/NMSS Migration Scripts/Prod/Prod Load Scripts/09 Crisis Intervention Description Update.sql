USE CFG_NMSS_PROD;

/******* Upsert Crisis Intervention Description *******/


--DROP table Case_TypeADesc_Update

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Crisis Intervention Case
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Case_CI_Update];
--GO
SELECT *
INTO [CFG_NMSS_PROD].[dbo].[Case_CI_Update]
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_CrisisInterventionDescription] 

SELECT * FROM [CFG_NMSS_PROD].[dbo].[Case_CI_Update]

--====================================================================
--INSERTING DATA USING DBAMP - Crisis Intervention
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:soap,batchsize(50)','CFG_NMSS_PROD','Case_CI_Update_3'

SELECT * 
--INTO Case_CI_Update_3
FROM Case_CI_Update_3_Result 
where Error <> 'Operation Successful.'

UPDATE Case_CI_Update_3
SET Description = dbo.RemoveInvalidXMLCharacters(Description)

select DISTINCT Error from Case_TypeADesc_Update_Result