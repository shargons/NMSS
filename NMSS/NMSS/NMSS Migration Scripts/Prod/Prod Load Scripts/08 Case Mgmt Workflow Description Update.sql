USE [CFG_NMSS_PROD];



--DROP table Case_Update

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Care Management Case
--====================================================================

DROP TABLE IF EXISTS [dbo].[Case_CType_Update];
GO
SELECT *
INTO [CFG_NMSS_PROD].[dbo].[Case_CType_Update]
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_CareMgmtDescription]  

SELECT * FROM [CFG_NMSS_PROD].[dbo].[Case_CType_Update]

--====================================================================
--INSERTING DATA USING DBAMP - Care Management Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PROD','Case_CType_Update'

SELECT * FROM Case_CType_Update_Result where Error ='Operation Successful.'

select DISTINCT Error from Case_Update_Result
