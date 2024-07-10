USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestLT]  
AS

SELECT
    NULL											AS [Id] -- Salesforce ID
	,IRT.InteractionDetailId						AS [DWUI_InteractionDetail_ID__c]
	,IRT.InteractionId								AS [DWUI_Interaction_ID__c]
	,IRT.InteractionId							    AS [Source_CaseID]  -- Source Case Lookup
	,C.Id											AS Case__c
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END											AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,'LiteratureType'+CAST(IRT.LiteratureTypeId AS NVARCHAR)								AS [Legacy_Interest__c]
	 ,I.Id										AS Interest__c
	 ,IRT.CreatedDate							    AS [CreatedDate]
FROM [TommiPrd1].[dbo].[apfx_InteractionDetailLiteratureType] IRT
INNER JOIN [CFG_NMSS_PROD].[dbo].[Case] C
	ON IRT.InteractionId = C.Data_Warehouse_ID__c
  INNER JOIN [CFG_NMSS_PROD].[dbo].[Interest__c] I
      ON I.DWUI_Literature_Type_ID__c = 'LiteratureType'+CAST(IRT.LiteratureTypeId AS NVARCHAR)
	LEFT JOIN [CFG_NMSS_PROD].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UC
		ON IRT.CreatedUserId = UC.[Data_Warehouse_ID__c]

     