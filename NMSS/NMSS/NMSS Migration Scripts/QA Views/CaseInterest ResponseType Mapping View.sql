USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestRT]  
AS

SELECT
    NULL											AS [Id] -- Salesforce ID
	,IRT.InteractionId								AS [LegacyID__c] -- Comment when DWUI Interaction fields are created
	,IRT.InteractionDetailId						AS [DWUI_Interaction_Detail__c]
	,IRT.InteractionId								AS [DWUI_Interaction__c]
	,IRT.InteractionId							    AS [Source_CaseID]  -- Source Case Lookup
	,C.SFID											AS Case__c
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END											AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,'ResponseType'+CAST(IRT.ResponseTypeId AS NVARCHAR)					AS [Legacy_Interest__c]
	 ,I.SFID										AS Interest__c
	 ,IRT.CreatedDate							    AS [CreatedDate]
FROM [TommiQA1].[dbo].[apfx_InteractionDetailResponseType] IRT
  INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Case] C
	ON IRT.InteractionId = C.DWID
  INNER JOIN [CFG_NMSS_QA].[dbo].[XREF_Interest] I
    ON I.DWID = 'ResponseType'+CAST(IRT.ResponseTypeId AS NVARCHAR)
	LEFT JOIN [CFG_NMSS_QA].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
		ON IRT.CreatedUserId = UC.[Data_Warehouse_ID__c]

     