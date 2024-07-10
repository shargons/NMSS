USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_ResourceType_Interest]    Script Date: 3/5/2024 12:54:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [vw_DW_CFG_ResponseCategory_Interest] AS
SELECT 
NULL																AS [Id] -- Salesforce ID
,'ResponseCategory'+CAST(ResponseCategoryId AS NVARCHAR(50))												AS [DWUI_Response_Type_ID__c] -- nvarchar(120)
,ResponseCategoryName												AS [Name] -- nvarchar(121)
,RC.CreatedDate                                                        AS [CreatedDate] -- DateTime
,RC.UpdatedDate													    AS [LastModifiedDate]
	,CASE 
		WHEN U.ID IS NULL THEN Us.ID
		ELSE U.ID 
	 END															AS [OwnerId]
	 ,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	 END															AS [CreatedById]
	 ,CASE 
		WHEN UL.ID IS NULL THEN Us.ID
		ELSE UL.ID 
	 END															AS [LastModifiedById]
	 ,0													AS IsActive__c
FROM [tommiprd1].[dbo].apfx_refResponseCategory RC
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] U
		ON RC.CreatedUserId = U.[Data_Warehouse_ID__c]
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UC
		ON RC.CreatedUserId = UC.[Data_Warehouse_ID__c]
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UL
		ON RC.UpdatedUserId = UL.[Data_Warehouse_ID__c]
WHERE RC.ActiveFlag = 1