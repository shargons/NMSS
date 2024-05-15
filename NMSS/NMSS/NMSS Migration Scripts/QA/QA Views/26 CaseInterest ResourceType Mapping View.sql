USE [CFG_NMSS_QA]
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
	,pr.InteractionDetailId						AS [DWUI_Interaction_Detail__c]
	,ix.InteractionId								AS [LegacyID__c] -- Comment when DWUI Interaction fields are created
	,ix.InteractionId								AS [DWUI_Interaction__c]
	,ix.InteractionId							    AS [Source_CaseID]  -- Source Case Lookup
	,C.SFID											AS Case__c
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END											AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,'ResourceType'+CAST(rt.ResourceTypeId AS NVARCHAR)								AS [Legacy_Interest__c]
	 ,I.SFID										AS Interest__c
	 ,rt.CreatedDate							    AS [CreatedDate]
FROM [TommiQA1].[dbo].apfx_interaction ix 
LEFT JOIN [TommiQA1].[dbo].apfx_interactiondetail id 
	on ix.interactionid = id.interactionid 
LEFT JOIN [TommiQA1].[dbo].apfx_InteractionDetailProviderReferral pr 
	on id.interactiondetailid = pr.interactiondetailid 
LEFT JOIN [TommiQA1].[dbo].apfx_refresourcetype rt 
	on pr.resourcetypeid = rt.resourcetypeid 
LEFT JOIN [TommiQA1].[dbo].apfx_refResourceCategory rc 
	on rt.resourcecategoryid = rc.resourcecategoryid
INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Case] C
	ON ix.InteractionId = C.DWID
  INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Interest] I
      ON I.DWID = 'ResourceType'+CAST(rt.resourcetypeid AS NVARCHAR)
	LEFT JOIN [CFG_NMSS_QA].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
		ON pr.CreatedUserId = UC.[Data_Warehouse_ID__c]

     