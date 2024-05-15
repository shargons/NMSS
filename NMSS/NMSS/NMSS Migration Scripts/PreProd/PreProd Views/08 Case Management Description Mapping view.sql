USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_CareMgmtDescription]  
AS
SELECT DISTINCT
	C.Id AS ID
	,cp.InteractionId as [Source_Interaction_Case]
	,  ISNULL(I.Comments,'')+CHAR(10)+CHAR(10)+'DWUI Interaction Detail :' + CAST(cs.InteractionDetailId AS nvarchar)+CHAR(10)+'Case Management'+CHAR(10)+ISNULL(id.Comments,'')+CHAR(10)+CHAR(10)+ISNULL(comm.Agg_Comments,'') AS [Description]
	--id.*
from TommiQA1.dbo.apfx_ConstituentKeyProcess cp 
join TommiQA1.dbo.apfx_constituentkeyprocessstep cs
		on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join TommiQA1.dbo.apfx_refkeyprocessstep rk 
		on cs.keyprocessstepid = rk.keyprocessstepid 
left join TommiQA1.dbo.apfx_ConstituentKeyProcessStepValue sv 
		on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join TommiQA1.dbo.apfx_ConstituentKeyProcessValue pv 
		on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join TommiQA1.dbo.apfx_refkeyprocessstatus st 
		on cp.keyprocessstatusid = st.keyprocessstatusid 
INNER JOIN [CFG_NMSS_QA].[dbo].[Case] C
		ON C.Data_Warehouse_ID__c = cp.InteractionId
LEFT JOIN [CFG_NMSS_QA].[dbo].[User] Us
			ON Us.Name = 'Migrations User'
LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
			ON cs.createduserid = UC.[Data_Warehouse_ID__c]
LEFT JOIN TommiQA1.dbo.apfx_Interaction I
		 ON i.InteractionId = cs.InteractionId
LEFT JOIN TommiQA1.dbo.apfx_InteractionDetail ID 
		 ON id.InteractionDetailId = cs.InteractionDetailId
LEFT JOIN 
	(SELECT csp.ConstituentKeyProcessId,STRING_AGG(CAST(csp.StepCompleteDate AS NVARCHAR)+CHAR(10)+CAST(csp.Comments AS NVARCHAR(MAX)),char(10)) as Agg_Comments 
		FROM [TommiQA1].[dbo].apfx_constituentkeyprocessstep csp 
		join TommiQA1.dbo.apfx_refkeyprocessstep rk 
		on csp.keyprocessstepid = rk.keyprocessstepid
		WHERE rk.LastStepFlag = 1
		group by csp.ConstituentKeyProcessId,csp.StepCompleteDate) comm
		ON comm.ConstituentKeyProcessId = cp.ConstituentKeyProcessId
where 
cs.ActiveFlag = 1 and rk.KeyProcessId = 3 
and CS.Comments is not null
--order by cp.ConstituentKeyProcessId,cs.constituentkeyprocessstepsequence 