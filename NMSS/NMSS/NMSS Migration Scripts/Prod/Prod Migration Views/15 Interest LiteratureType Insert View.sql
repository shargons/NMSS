USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_ResourceType_Interest]    Script Date: 3/5/2024 12:54:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [vw_DW_CFG_LiteratureType_Interest] AS
SELECT 
NULL																AS [Id] -- Salesforce ID
,'LiteratureType'+CAST(LiteratureTypeId AS NVARCHAR(50))				AS [DWUI_Literature_Type_ID__c] -- nvarchar(120)
,LiteratureTypeName													AS [Name] -- nvarchar(121)
,'LiteratureCategory'+CAST(LiteratureCategoryId AS NVARCHAR(50))	AS [Source_cfg_Interests__ParentInterest__c] -- Parent Interest
,RT.CreatedDate                                                     AS [CreatedDate] -- DateTime
,RT.UpdatedDate													    AS [LastModifiedDate]
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
FROM [TommiPrd1].[dbo].[apfx_refLiteratureType] RT 
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] U
		ON RT.CreatedUserId = U.[Data_Warehouse_ID__c]
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[User] Us
		ON Us.Name = 'Migrations User'
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UC
		ON RT.CreatedUserId = UC.[Data_Warehouse_ID__c]
	 LEFT JOIN [CFG_NMSS_PROD].[dbo].[vw_DW_CFG_User] UL
		ON RT.UpdatedUserId = UL.[Data_Warehouse_ID__c]
WHERE RT.ActiveFlag = 1