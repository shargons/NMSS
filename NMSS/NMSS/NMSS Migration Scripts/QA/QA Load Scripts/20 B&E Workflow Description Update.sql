USE [CFG_NMSS_PREPROD];

/******* Checking for any Open BET Cases for Updating the Status to Open *******/

        -- get recent Case data downloaded using SF_Replicate --
EXEC SF_Replicate 'CFG_NMSS_PREPROD','Case','pkchunk,batchsize(50000)',1

-- Get B&E Incomplete workflows to change status to open and Date/Time Closed to blank
--DROP TABLE Case_BE_Date_StatusUpdate
select DISTINCT C.ID,
CASE WHEN cp.CompleteFlag = 1 THEN DATEADD(hour, 24, DATEDIFF(DAY, 0, cp.completeDate))
ELSE NULL
END AS ClosedDate
,CASE WHEN cp.CompleteFlag = 1 THEN 'Closed'
ELSE 'Service Navigation'
END AS Status
--INTO Case_BE_Date_StatusUpdate
from nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcess cp 
join  nmss_src.TommiQA1.dbo.apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join  nmss_src.TommiQA1.dbo.apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join nmss_src.TommiQA1.dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join nmss_src.TommiQA1.dbo.apfx_secUser su on cs.createduserid = su.userid 
join nmss_src.TommiQA1.dbo.apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
join [CFG_NMSS_QA].[dbo].[Case] C on c.Data_Warehouse_ID__c = CP.InteractionId
where 
cs.ActiveFlag = 1 and rk.KeyProcessId = 2 

--order by cp.ConstituentKeyProcessId,cs.constituentkeyprocessstepsequence 
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_QA','Case_BE_Date_StatusUpdate'

SELECT * 
FROM Case_BE_Date_StatusUpdate_Result
WHERE Error <> 'Operation Successful.'

/******* Upsert BET Comments *******/


--DROP table Case_Update

--====================================================================
--	UPDATING DATA TO THE LOAD TABLE FROM THE VIEW - BET Case
--====================================================================

DROP TABLE IF EXISTS [dbo].[Case_Update];
GO
SELECT *
INTO [CFG_NMSS_PREPROD].[dbo].[Case_Update]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_B&EDescription]

SELECT * FROM [CFG_NMSS_PREPROD].[dbo].[Case_Update]

--====================================================================
--INSERTING DATA USING DBAMP - BET Case
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Update:BULKAPI','CFG_NMSS_PREPROD','Case_Update'

SELECT * FROM Case_Update_Result where Error ='Operation Successful.'

select DISTINCT Error from Case_Update_Result
