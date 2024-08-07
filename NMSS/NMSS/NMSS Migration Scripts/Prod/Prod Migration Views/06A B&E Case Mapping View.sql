USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_B&ECases]  
AS

SELECT * 
FROM 
(
	SELECT DISTINCT
	NULL																				AS [Id] -- Salesforce ID
	,I.InteractionId																	AS [Data_Warehouse_ID__c]  -- Source Warehouse_id
	,I.ConstituentId																	AS [Source_WhoId]	-- Lookup(Contact)
	, DATEADD(hour, 12, DATEDIFF(DAY, 0, cp.CompleteDate))								AS [ClosedDate]
	,IM.InteractionModeName																AS [Origin] -- Picklist
	,IT.InteractionCategoryName															AS [Type] -- Picklist
	,ISNULL(I.ConfidentialFlag,0)														AS [Confidential__c]
	,CASE
		WHEN cp.CompleteFlag = 1  THEN 'Closed'
		ELSE 'Service Navigation'
	 END																				AS [Status] -- Picklist
	,DATEADD(hour, 12, DATEDIFF(DAY, 0, cp.CreatedDate))							    AS [CreatedDate] -- DateTime
	,I.Comments																			AS [Description] -- Long Text
	,id.DetailTypeCode
	,'B&E'																				AS [Subject] --  Text
	,CASE 
		WHEN U.ID IS NULL THEN Us.ID
		ELSE U.ID 
	 END																				AS [OwnerId]
	 ,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END																				AS	[CreatedById]
	 ,CASE 
		WHEN UL.ID IS NULL THEN Us.ID
		ELSE UL.ID 
	 END																				AS [LastModifiedById]
	 ,R.ID																				AS RecordTypeId
	FROM [Tommiprd1].dbo.apfx_Interaction I
		left join [Tommiprd1].dbo.apfx_interactiondetail id 
			on i.interactionid = id.interactionid
		left join [Tommiprd1].dbo.apfx_InteractionDetailResponseType rt 
			on rt.interactiondetailid = id.interactiondetailid and rt.ActiveFlag = 1
		left join [Tommiprd1].dbo.apfx_refResponseType rr 
			on rt.ResponseTypeId = rr.ResponseTypeId
		left join [Tommiprd1].dbo.apfx_refResponseCategory rc 
			on rr.ResponseCategoryId = rc.ResponseCategoryId
		left join [Tommiprd1].dbo.apfx_sysInteractionDetailType dt 
			on dt.DetailTypeCode = id.DetailTypeCode
		 LEFT JOIN [Tommiprd1].dbo.apfx_refInteractionCategory IT
			ON I.InteractionCategoryId = IT.InteractionCategoryId
		 LEFT JOIN  [Tommiprd1].dbo.apfx_refInteractionMode IM
			ON I.InteractionModeId = IM.InteractionModeId
		 LEFT JOIN [Tommiprd1].dbo.apfx_Tickler T
			ON T.InteractionId = I.InteractionId
		 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] U
			ON T.AssignedToUserId = U.[Data_Warehouse_ID__c]
		 LEFT JOIN [CFG_NMSS_PROD].[dbo].[User] Us
			ON Us.Name = 'Migrations User'
		 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UC
			ON I.CreatedUserId = UC.[Data_Warehouse_ID__c]
		 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UL
			ON I.UpdatedUserId = UL.[Data_Warehouse_ID__c]
		LEFT JOIN [CFG_NMSS_PROD].[dbo].[Recordtype] R
		ON R.DeveloperName = 'Navigator_Support_Request'
			LEFT JOIN [Tommiprd1].dbo.apfx_ConstituentKeyProcess cp
	    ON cp.InteractionId = I.InteractionId
	WHERE I.ActiveFlag = 1
	and I.interactioncategoryid in (59,61) --Strategy Area for Advocacy and Services
	and (rc.ResponseCategoryId in (232,207,209,198,195,228) --These are the Tier 1 Response Categories used by Services
	or id.ResponseTypeId = 634 --This is necessary to get the Hot Topic Interactions
	or id.DetailTypeCode in ('B')) --These are all the non-Tier 1 interaction categories
	and id.ActiveFlag = 1 
)X
WHERE X.DetailTypeCode = 'B'
GO


