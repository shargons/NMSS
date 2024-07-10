USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestResoT]  
AS

SELECT DISTINCT
    NULL											AS [Id] -- Salesforce ID
	,pr.InteractionDetailId						    AS [DWUI_Interaction_Detail_ID__c]
	,ix.InteractionId								AS [DWUI_Interaction_ID__c]
	,ix.InteractionId							    AS [Source_CaseID]  -- Source Case Lookup
	,C.Id											AS Case__c
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END											AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,'ResourceType'+CAST(rt.ResourceTypeId AS NVARCHAR)								AS [Legacy_Interest__c]
	 ,I.Id										AS Interest__c
	 ,rt.CreatedDate							    AS [CreatedDate]
FROM [tommiprd1].[dbo].apfx_interaction ix 
LEFT JOIN [tommiprd1].[dbo].apfx_interactiondetail id 
	on ix.interactionid = id.interactionid 
LEFT JOIN [tommiprd1].[dbo].apfx_InteractionDetailProviderReferral pr 
	on id.interactiondetailid = pr.interactiondetailid 
LEFT JOIN [tommiprd1].[dbo].apfx_refresourcetype rt 
	on pr.resourcetypeid = rt.resourcetypeid 
LEFT JOIN [tommiprd1].[dbo].apfx_refResourceCategory rc 
	on rt.resourcecategoryid = rc.resourcecategoryid
INNER JOIN [CFG_NMSS_PROD].[dbo].[Case] C
	ON ix.InteractionId = C.Data_Warehouse_ID__c
  INNER JOIN [CFG_NMSS_PROD].[dbo].[Interest__c] I
      ON I.DWUI_Resource_Type_ID__c = 'ResourceType'+CAST(rt.resourcetypeid AS NVARCHAR)
	LEFT JOIN [CFG_NMSS_PROD].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UC
		ON pr.CreatedUserId = UC.[Data_Warehouse_ID__c]

     