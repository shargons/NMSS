USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_LeveragedFARequest]  
AS

SELECT DISTINCT
  NULL AS ID
, DWUI_Interaction_ID__c
, DWUI_Interaction_Detail_ID__c
, DWUI_Constituent_Key_Process_ID__c
, Source_Beneficiary_Contact__c
, CreatedDate
, Source_CaseID
, Decision_Date__c
, Status__c 
, MAX(Award_Amount__c) AS Award_Amount__c
, Award_Type__c
, Award_Description__c
, MAX(Benefit_Type__c) AS Benefit_Type__c
, CASE	   WHEN MAX(Benefit_Type__c) IN ('Aids for Daily Living','Assistive Technology Devices - High Tech','Auto Modification','Home Modification','Ramp','Reacher/Grabber','Stair Glide') THEN 'Access Mods'
		   WHEN MAX(Benefit_Type__c) IN ('Transportation') THEN 'Transportation'
		   WHEN MAX(Benefit_Type__c) IN ('Crisis/Emergency Service','Food and Dietary Supplements','Furnace','Furniture','Rent Mortgage and Utilities','Water Heater') THEN 'Critical Short Term Needs'
		   WHEN MAX(Benefit_Type__c) IN ('Prof. Individual Counseling - In Person','Prof. Individual Counseling - Phone') THEN 'Mental Health Support'
		   WHEN MAX(Benefit_Type__c) IN ('Air Conditioner','Cane','Commode','Cooling Garments','Crutches','DME Repair','Equipment Assistance','Gel Cushions','GrabBars','Hospital Bed','Lift Chair','Lift','Raised Toilet Seat','Rolling Shower Chair','Scooter Electric','Shower/TubBench','Tub Transfer Bench','Walk Aide','Walker','Walker with Wheels','Wheelchair Manual','Wheelchair Power') THEN 'DME'
		   WHEN MAX(Benefit_Type__c) IN ('Dental Assistance','Exercise/Recreation Therapy Fees or Supplies','Incontinence Supplies','Medications or Medical Care','MS Clinic Visit','Occupational Therapy','Physical Therapy','Rehab Evals/Services','Rehab Evals/Services') THEN 'Health and Wellness'
		   WHEN MAX(Benefit_Type__c) IN ('Adult Day Center/Care','Chore Services','Home Care','Independent Living','Respite Care Services') THEN 'Respite Services'
	   ELSE 'Other'
	END   as Spend_Category__c
, OwnerId
, CreatedById
FROM 
(
	SELECT 
	  cp.InteractionId														as DWUI_Interaction_ID__c
	, cs.InteractionDetailId												as DWUI_Interaction_Detail_ID__c
	, cp.ConstituentKeyProcessId											as DWUI_Constituent_Key_Process_ID__c
	, cp.ConstituentId														as Source_Beneficiary_Contact__c
	, DATEADD(hour, 12, DATEDIFF(DAY, 0, cp.StartDate))						as CreatedDate
	, cp.InteractionId														as Source_CaseID
	, DATEADD(hour, 12, DATEDIFF(DAY, 0, cp.CompleteDate))                  as Decision_Date__c
	, CASE WHEN cp.CompleteFlag = 1 THEN 'Leveraged Resources Received'
		   ELSE 'Active FA Payments' 
	  END																    as Status__c
	, amount.Agg_DollarAmount                                                        as Award_Amount__c 
	, 'Leveraged'															as Award_Type__c
	, CASE WHEN rk.LastStepFlag = 1 THEN ISNULL(cs.Comments,'')+char(10)+char(10)+ISNULL(Agg_Desc_Comment.Comment_TypeDesc,'')
	  ELSE  ISNULL(Agg_Comments,'')+char(10)+char(10)+ISNULL(Agg_Desc_Comment.Comment_TypeDesc,'')
	  END																	as Award_Description__c
	, IIF(vt.AccountingSegment IS NOT NULL,REPLACE(vt.KeyProcessValueTypeName,' Leveraged Funds',''),NULL) as Benefit_Type__c                                                                
	, CASE 
			 WHEN U.ID IS NULL THEN Us.ID
			 ELSE U.ID 
     END																	as [OwnerId]
	,CASE 
			 WHEN UC.ID IS NULL THEN Us.ID
			 ELSE UC.ID 
	END	                                                                    as [CreatedById]
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
	LEFT JOIN 
	(SELECT csv.ConstituentKeyProcessId,SUM(csv.dollaramount) as Agg_DollarAmount 
		FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcessValue csv
		     JOIN [TommiQA1].[dbo].apfx_refKeyProcessValueType vt 
	on csv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
		WHERE vt.KeyProcessValueCategoryId = 5
		group by csv.ConstituentKeyProcessId) amount
	on amount.ConstituentKeyProcessId = cp.ConstituentKeyProcessId
	LEFT JOIN 
	(SELECT ConstituentKeyProcessId,STRING_AGG(Agg_TypeDesc,CHAR(10)+CHAR(10)) AS Comment_TypeDesc
		FROM (
		SELECT csv.ConstituentKeyProcessId,'Award Amount :'+ISNULL(CAST(csv.DollarAmount AS NVARCHAR),'')+char(10)
		+'Spend Category :'+
		CASE WHEN MAX(vt.KeyProcessValueTypeName) IN ('Aids for Daily Living','Assistive Technology Devices - High Tech','Auto Modification','Home Modification','Ramp','Reacher/Grabber','Stair Glide') THEN 'Access Mods'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Transportation') THEN 'Transportation'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Crisis/Emergency Service','Food and Dietary Supplements','Furnace','Furniture','Rent Mortgage and Utilities','Water Heater') THEN 'Critical Short Term Needs'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Prof. Individual Counseling - In Person','Prof. Individual Counseling - Phone') THEN 'Mental Health Support'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Air Conditioner','Cane','Commode','Cooling Garments','Crutches','DME Repair','Equipment Assistance','Gel Cushions','GrabBars','Hospital Bed','Lift Chair','Lift','Raised Toilet Seat','Rolling Shower Chair','Scooter Electric','Shower/TubBench','Tub Transfer Bench','Walk Aide','Walker','Walker with Wheels','Wheelchair Manual','Wheelchair Power') THEN 'DME'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Dental Assistance','Exercise/Recreation Therapy Fees or Supplies','Incontinence Supplies','Medications or Medical Care','MS Clinic Visit','Occupational Therapy','Physical Therapy','Rehab Evals/Services','Rehab Evals/Services') THEN 'Health and Wellness'
			  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Adult Day Center/Care','Chore Services','Home Care','Independent Living','Respite Care Services') THEN 'Respite Services'
			 ELSE 'Other' END
		+char(10)+'Benefit Type :'+ISNULL(vt.KeyProcessValueTypeName,'')
		as Agg_TypeDesc
				FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcessValue csv
					 JOIN [TommiQA1].[dbo].apfx_refKeyProcessValueType vt 
			on csv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
				WHERE vt.KeyProcessValueCategoryId = 2 
				group by csv.ConstituentKeyProcessId,csv.DollarAmount,vt.KeyProcessValueTypeName
			)Comment_Desc
		GROUP BY ConstituentKeyProcessId) Agg_Desc_Comment
		on Agg_Desc_Comment.ConstituentKeyProcessId = cp.ConstituentKeyProcessId
	where  cs.ActiveFlag = 1 and vc.KeyProcessValueCategoryName = 'Leveraged Financial Benefit' and cp.KeyProcessId = 1
)X
--WHERE X.DWUI_Constituent_Key_Process_ID__c = 152620518
GROUP BY DWUI_Interaction_ID__c,DWUI_Interaction_Detail_ID__c,DWUI_Constituent_Key_Process_ID__c,Source_Beneficiary_Contact__c
,CreatedDate,Source_CaseID,Decision_Date__c,Status__c,Award_Type__c,Award_Description__c,OwnerId,CreatedById

