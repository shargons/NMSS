	
	
	
USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_DirectFAPayment]  
AS
	
SELECT DISTINCT
  NULL																					    as ID
, cp.InteractionId																		    as DWUI_Interaction_ID__c
, cp.ConstituentKeyProcessId																as DWUI_Constituent_Process_ID__c
, cp.ConstituentKeyProcessId																as Source_FA_Request
, cp.InteractionId																			as Source_CaseID
, cp.ConstituentId																			as Source_Constituent__c
, pv.ValueDate																				as Payment_Date__c
, IIF(vc.KeyProcessValueCategoryName = 'Awarded Financial Benefit' , pv.DollarAmount,NULL)  as Amount__c 
, CASE 
	 WHEN U.ID IS NULL THEN Us.ID
	 ELSE U.ID 
  END																						as [OwnerId]
,CASE 
	 WHEN UC.ID IS NULL THEN Us.ID
	 ELSE UC.ID 
 END																			            as [CreatedById]
, 'Paid'	as Status__c
,pv.DollarAmount
,vc.KeyProcessValueCategoryName
,cp.CompleteFlag
FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcess cp 
JOIN [TommiQA1].[dbo].apfx_constituentkeyprocessstep cs 
	on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
JOIN [TommiQA1].[dbo].apfx_refkeyprocessstep rk 
	on cs.keyprocessstepid = rk.keyprocessstepid 
LEFT JOIN [TommiQA1].[dbo].apfx_ConstituentKeyProcessStepValue sv 
	on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
LEFT JOIN [TommiQA1].[dbo].apfx_ConstituentKeyProcessValue pv 
	on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
JOIN [TommiQA1].[dbo].apfx_secUser su 
	on cs.createduserid = su.userid 
JOIN [TommiQA1].[dbo].apfx_refkeyprocessstatus st 
	on cp.keyprocessstatusid = st.keyprocessstatusid 
LEFT JOIN [TommiQA1].[dbo].apfx_refKeyProcessValueType vt 
	on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
LEFT JOIN [TommiQA1].[dbo].apfx_sysKeyProcessValueCategory vc 
	on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
LEFT JOIN 
(SELECT csp.ConstituentKeyProcessId,STRING_AGG(CAST(csp.Comments AS NVARCHAR(MAX)),char(10)) as Agg_Comments 
	FROM [TommiQA1].[dbo].apfx_constituentkeyprocessstep csp 
	group by csp.ConstituentKeyProcessId) comm
on comm.ConstituentKeyProcessId = cp.ConstituentKeyProcessId
LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] U
			ON cp.CreatedUserId = U.[Data_Warehouse_ID__c]
LEFT JOIN [CFG_NMSS_QA].[dbo].[User] Us
			ON Us.Name = 'Migrations User'
LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
			ON cp.CreatedUserId = UC.[Data_Warehouse_ID__c]
where  cs.ActiveFlag = 1 and vc.KeyProcessValueCategoryName = 'Awarded Financial Benefit'  
--and cp.CompleteFlag = 1 
--and cp.ConstituentKeyProcessId = 113130314
ORDER BY cp.ConstituentKeyProcessId 
OFFSET 0 ROWS
