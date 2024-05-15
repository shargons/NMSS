USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestAType]  
AS

SELECT
    NULL											AS [Id] -- Salesforce ID
	,C.InteractionDetailId							AS [DWUI_Interaction_Detail_Id__c]
	,C.[Data_Warehouse_ID__c]						AS [DWUI_Interaction_Id__c]
	,C.[Data_Warehouse_ID__c]						AS [Source_CaseID]  -- Source Case Lookup
	,CL.Id										AS Case__c
	,C.[CreatedById]								AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,I.DWUI_Response_Type_ID__c										AS [Legacy_Interest__c]
	 ,I.Id										AS Interest__c
	 ,C.CreatedDate									AS [CreatedDate]
FROM [CFG_NMSS_QA].[dbo].[vw_DW_CFG_CrisisInterventionCases] C
INNER JOIN [CFG_NMSS_QA].[dbo].[Case] CL
ON C.[Data_Warehouse_ID__c] = CL.Data_Warehouse_ID__c
INNER JOIN [CFG_NMSS_QA].[dbo].Interest__c I
ON I.DWUI_Response_Type_ID__c ='ResponseType364'

     