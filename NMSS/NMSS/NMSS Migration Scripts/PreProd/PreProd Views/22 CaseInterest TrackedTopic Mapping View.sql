USE [CFG_NMSS_PREPROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestTT]  
AS

SELECT
    NULL											AS [Id] -- Salesforce ID
	,IRT.InteractionDetailId						AS [DWUI_Interaction_Detail_ID__c]
	,IRT.InteractionId								AS [DWUI_Interaction_ID__c]
	,IRT.InteractionId							    AS [Source_CaseID]  -- Source Case Lookup
	,C.Id											AS Case__c
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END											AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,'TrackedTopic'+CAST(IRT.TrackedTopicId AS NVARCHAR)								AS [Legacy_Interest__c]
	 ,I.Id										AS Interest__c
	 ,IRT.CreatedDate							    AS [CreatedDate]
FROM [NMSS_SRC].[TommiQA1].[dbo].[apfx_InteractionDetailTrackedTopic] IRT
  INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Case] C
	ON IRT.InteractionId = C.Data_Warehouse_ID__c
  INNER JOIN [CFG_NMSS_PREPROD].[dbo].[Interest__c] I
    ON I.DWUI_Tracked_Topic_ID__c = 'TrackedTopic'+CAST(IRT.TrackedTopicId AS NVARCHAR)
	LEFT JOIN [CFG_NMSS_PREPROD].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	LEFT JOIN [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
		ON IRT.CreatedUserId = UC.[Data_Warehouse_ID__c]

     