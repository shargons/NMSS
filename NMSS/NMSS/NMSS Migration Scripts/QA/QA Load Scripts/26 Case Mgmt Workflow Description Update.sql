USE [CFG_NMSS_QA];

/******* Checking for any Open Type C Cases for Updating the Status to Open *******/

        -- get recent Case data downloaded using SF_Replicate --

select DISTINCT C.ID,
CASE WHEN cp.CompleteFlag = 1 THEN cp.completeDate
--DATEADD(hour, 0, DATEDIFF(DAY, 12, cp.completeDate))
ELSE NULL
END AS ClosedDate
,CASE WHEN cp.CompleteFlag = 1 THEN 'Closed'
ELSE 'Case Management'
END AS Status
--INTO Case_TypeC_Date_StatusUpdate
from nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcess cp 
join  nmss_src.TommiQA1.dbo.apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join  nmss_src.TommiQA1.dbo.apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join nmss_src.TommiQA1.dbo.apfx_secUser su on cs.createduserid = su.userid 
join nmss_src.TommiQA1.dbo.apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
join [CFG_NMSS_QA].[dbo].[Case] C on c.Data_Warehouse_ID__c = CP.InteractionId
where 
cs.ActiveFlag = 1 and rk.KeyProcessId = 3 
--and cp.ConstituentId = 61790150
--order by cp.ConstituentKeyProcessId,cs.constituentkeyprocessstepsequence 

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Case_BE_Date_StatusUpdate'

/******* Upsert Care Management Comments *******/


--DROP table Case_Update

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - Care Management Case
--====================================================================

DROP TABLE IF EXISTS [dbo].[Case_CType_Update];
GO
SELECT *
INTO [CFG_NMSS_QA].[dbo].[Case_CType_Update]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_CareMgmtDescription]  

SELECT * FROM [CFG_NMSS_QA].[dbo].[Case_CType_Update]

--====================================================================
--INSERTING DATA USING DBAMP - Care Management Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Case_CType_Update'

SELECT * FROM Case_CType_Update_Result where Error ='Operation Successful.'

select DISTINCT Error from Case_Update_Result
