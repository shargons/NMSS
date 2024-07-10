USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/18/2024 6:19:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_CaseInterestB&EType]  
AS

SELECT
    NULL											AS [Id] -- Salesforce ID
	--,C.InteractionDetailId							AS [DWUI_Interaction_Detail_ID__c]
	,C.[Data_Warehouse_ID__c]						AS [DWUI_Interaction_ID__c]
	,C.[Data_Warehouse_ID__c]						AS [Source_CaseID]  -- Source Case Lookup
	,CL.Id										AS Case__c
	,C.[CreatedById]								AS [CreatedById]
	 ,1												AS [IsCurrent__c]
	 ,I.DWUI_Response_Type_ID__c										AS [Legacy_Interest__c]
	 ,I.Id										AS Interest__c
	 ,C.CreatedDate									AS [CreatedDate]
FROM [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_B&ECases] C
INNER JOIN [CFG_NMSS_PROD].[dbo].[Case] CL
ON C.[Data_Warehouse_ID__c] = CL.Data_Warehouse_ID__c
INNER JOIN [CFG_NMSS_PROD].[dbo].Interest__c I
ON I.DWUI_Response_Type_ID__c ='ResponseCategory204'

     