USE CFG_NMSS_PREPROD;

/******* Upsert Crisis Intervention Description *******/


--DROP table Case_TypeADesc_Update

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Crisis Intervention Case
--====================================================================

--DROP TABLE IF EXISTS [dbo].[Case_TypeADesc_Update];
--GO
SELECT *
INTO [CFG_NMSS_PREPROD].[dbo].[Case_CI_Update]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_CrisisInterventionDescription] 

SELECT * FROM [CFG_NMSS_PREPROD].[dbo].[Case_CI_Update]

--====================================================================
--INSERTING DATA USING DBAMP - Crisis Intervention
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update','CFG_NMSS_PREPROD','Case_CI_Update'

SELECT * FROM Case_TypeADesc_Update_Result where Error ='Operation Successful.'

select DISTINCT Error from Case_TypeADesc_Update_Result