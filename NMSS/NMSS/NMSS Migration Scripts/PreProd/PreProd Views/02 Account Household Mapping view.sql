

USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_SFDC_Account_Household]    Script Date: 2/22/2024 12:51:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:       Traction
-- Create date: 2018-10-02
-- Description: Transforms DW household data to match salesforce schema     
--              leveraged by Boomi processes : 0010_DW_SFDC_BDE_Household_master


-- Alter date: 2019-04-04
-- Description: Added the Qualified_entity condition(NMSSI-582) and also removed the SSIS User filter(NMSSI-584).
--
-- Alter date: 2019-04-05
-- Description: removed the OwnerID field(NMSSI-570).
--
-- Alter date: 2019-04-25
-- Description: removed the ActiveFlag filter(NMSSI-226).
--
-- =============================================
-- Alter date: 2019-10-18
-- Description: DS-613, updated HHD logic to follow same qualified change logic as contacts 
--
-- =============================================
-- Alter date: 2019-10-27
-- Description: DS-613, updated HHD logic to only select one row per HHD ID 
--
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 12-17-2019
-- Description: DS_697: Filter out inactive Households
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 08-14-2020
-- Description: DS_755: Add Market to Household
-- =============================================
CREATE OR ALTER View [dbo].[vw_DW_SFDC_Account_Household] AS 

SELECT  
    XREF.SFID                      AS [Id] -- Salesforce ID 
,   CONCAT('HHD', H.HouseholdId)                   AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
,   'Replaced by Household Naming Rules'           AS [Name] --  nvarchar(255)
,   RT.Id                                          AS [Source_RecordTypeId]  -- Source ID for look up to RecordType
,   CASE WHEN H.CreatedDate<H.UpdatedDate THEN H.CreatedDate ELSE H.UpdatedDate END  AS [CreatedDate] --  datetime
,   H.UpdatedDate                                  AS [LastModifiedDate] --  datetime
,   H.ActiveFlag                                   AS [Active__c] --  bit
,	M.Market__c     							   AS [Market__c]
FROM [CFG_NMSS_PROD].dbo.tbl_Qualified_Entity as qe with(nolock)
INNER JOIN [NMSS_PRD].[Tommiprd1].[dbo].apfx_Entity AS E
	ON E.EntityId = QE.EntityId
INNER JOIN [NMSS_PRD].[Tommiprd1].[dbo].apfx_Household AS H
	ON 	E.HouseholdId = H.HouseholdId
LEFT JOIN [NMSS_PRD].[SFIntegration].dbo.vw_NMSS_help_Household_Market m
	ON m.Data_Warehouse_ID__c = h.householdid
LEFT JOIN [dbo].[RecordType] AS RT ON 
      RT.Name='Household' AND RT.sObjectType='Account'
LEFT JOIN [NMSS_PRD].[SFIntegration].dbo.XREF_Account_Household as xref
	ON XREF.DWID = CONCAT('HHD', H.HouseholdId)
WHERE	
XREF.SFID IS NULL and
--QE.Entity_Type = 'I' and 
h.ActiveFlag = 1

UNION

SELECT  
    XREF.SFID                      AS [Id] -- Salesforce ID 
,   CONCAT('HHD', H.HouseholdId)                   AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
,   'Replaced by Household Naming Rules'           AS [Name] --  nvarchar(255)
,   RT.Id                                          AS [Source_RecordTypeId]  -- Source ID for look up to RecordType
,   CASE WHEN H.CreatedDate<H.UpdatedDate THEN H.CreatedDate ELSE H.UpdatedDate END  AS [CreatedDate] --  datetime
,   H.UpdatedDate                                  AS [LastModifiedDate] --  datetime
,   H.ActiveFlag                                   AS [Active__c] --  bit
,	M.Market__c						         	   AS [Market__c]
FROM [CFG_NMSS_PROD].dbo.tbl_Qualified_Entity as qe with(nolock)
INNER JOIN [NMSS_PRD].[Tommiprd1].[dbo].apfx_Entity AS E
	ON E.EntityId = QE.EntityId
INNER JOIN [NMSS_PRD].[Tommiprd1].[dbo].apfx_Household AS H
	ON 	E.HouseholdId = H.HouseholdId
LEFT JOIN [NMSS_PRD].[SFIntegration].dbo.vw_NMSS_help_Household_Market m
	ON m.Data_Warehouse_ID__c = h.householdid
LEFT JOIN [CFG_NMSS_PROD].[dbo].[RecordType] AS RT ON 
      RT.Name='Household' AND RT.sObjectType='Account'
LEFT JOIN [CFG_NMSS_PROD].dbo.XREF_Account_Household as xref
	ON XREF.DWID = CONCAT('HHD', H.HouseholdId)
WHERE	
--QE.Entity_Type = 'I' and 
XREF.SFID IS NULL
and h.ActiveFlag = 1
GO


