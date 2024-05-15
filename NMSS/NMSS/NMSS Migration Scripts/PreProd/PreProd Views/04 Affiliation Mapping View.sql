USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_SFDC_Affiliation]    Script Date: 3/14/2024 11:33:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/*
   Author                      :  Jhansi M
   Folder                      :  BDE_Affiliation
   Dell Boomi Process names    :  DW_SFDC_Affiliation,SFDC_DW_Affiliation,DW_SFDC_Affiliation_Master
   Integration Type            :  Bidirectional Edit
   DW to SFDC View name        :  [dbo].[DW_SFDC_Affiliation]
   DW to SFDC ToIntegrate Table:  [dbo].[DW_SFDC_Affiliation_ToIntegrate]
   XREF Table                  :  [dbo].[XREF_Affiliation]
   DW to SFDC Stored procedure :  [dbo].[sp_DW_SFDC_Affiliation]
   Dedupe Stored Procedure     :  [dbo].[sp_Dedupe_Affiliation]
   Upsert Stored Procedure     :  [dbo].[sp_Upsert_Affiliation_From_SFDC_Affiliation]
   ForImport Table             :  [dbo].[SFDC_DW_Affiliation_ForImport] 



-- Alter date: 2019-05-01
-- Description: changed the whole view based on the ticket CRM-226.
--
-- Alter date: 2019-05-14
-- Description: changed the whole view based on the ticket CRM-289.
--

-- Alter date: 2019-08-09
-- Author: Vinnie Pisaniello
-- Description: Updated view for CRM-496, only include active entityid's if not know to SF.
    
*/

CREATE OR ALTER   View [dbo].[vw_DW_SFDC_Affiliation] AS            
SELECT  
    XA.SFID											AS [Id] -- Salesforce ID 
	,ER.SF_UniqueKey                                AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
	,CASE 
		WHEN ER.UpdatedDate < ER.CreatedDate 
		THEN ER.UpdatedDate 
		ELSE ER.CreatedDate 
		END											AS [CreatedDate] --  datetime
	,ER.UpdatedDate                                 AS [LastModifiedDate] --  datetime
	,CONCAT('ENT', CASE 
					WHEN E1.EntityCategoryCode='O' THEN E1.EntityId 
					ELSE E2.EntityId 
					END)							AS [Source_npe5__Organization__c]  -- Source ID for look up to Account
	,CASE 
		WHEN E1.EntityCategoryCode='I' THEN E1.EntityId 
		ELSE E2.EntityId 
		END											AS [Source_npe5__Contact__c]  -- Source ID for look up to Contact
	,ER.Comment                                     AS [npe5__Description__c] --  ntext(8)
	,ER.EndDate                                     AS [npe5__EndDate__c] --  date
	,ER.BeginDate                                   AS [npe5__StartDate__c] --  date
	,CASE 
		WHEN ER.ActiveFlag=1 THEN 'Current' 
		ELSE 'Former' 
		END											AS [npe5__Status__c] --  nvarchar(255)
	,CASE 
		WHEN E1.EntityCategoryCode='I' THEN rRT1.RelationshipTypeName 
		ELSE rRT2.RelationshipTypeName 
		END											AS [Role__c] --  nvarchar(255)
FROM 
	tbl_Qualified_Entity AS qe with(nolock)
	LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	ON QE.EntityId = ER.EntityId
	--JOIN SFIntegration.ct.ChangedEntityRelationshipIds as ChangeSet  with(nolock)
		--ON ER.SF_UniqueKey = ChangeSet.SF_UniqueKey
	JOIN TommiQA1.dbo.apfx_refRelationshipType as rRT1  with(nolock)
		ON ER.RelationshipTypeId = rRT1.RelationshipTypeId
	JOIN TommiQA1.dbo.apfx_refRelationshipType as rRT2  with(nolock)
		ON rRT1.ReciprocalRelationshipTypeId = rRT2.RelationshipTypeId
	JOIN TommiQA1.dbo.apfx_EntityRelationship AS ER2 with(nolock)
		ON ER.ReferencedEntityId = ER2.EntityId
		AND ER.EntityId = ER2.ReferencedEntityId
		AND rRT1.ReciprocalRelationshipTypeId = ER2.RelationshipTypeId
		--AND ER.SF_UniqueKey > ER2.SF_UniqueKey -- Migrate and integrate the latter of the two relationship records. Code within SF will create/update/delete a reciprocal
	JOIN TommiQA1.dbo.apfx_Entity as E1  with(nolock)
		ON ER.EntityId = E1.EntityId
	JOIN TommiQA1.dbo.apfx_Entity as E2  with(nolock)
		ON ER.ReferencedEntityId = E2.EntityId
	LEFT JOIN SFIntegration.dbo.XREF_Relationship as XR with(nolock)
		ON ER.SF_UniqueKey = XR.DWID
	LEFT JOIN SFIntegration.dbo.XREF_Affiliation as XA with(nolock)
		ON ER.SF_UniqueKey = XA.DWID
WHERE 
	XA.DWID is not null AND XA.SFID IS NULL
UNION
SELECT  
    XA.SFID											AS [Id] -- Salesforce ID 
	,ER.SF_UniqueKey                                AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
	,CASE 
		WHEN ER.UpdatedDate < ER.CreatedDate 
		THEN ER.UpdatedDate 
		ELSE ER.CreatedDate 
		END											AS [CreatedDate] --  datetime
	,ER.UpdatedDate                                 AS [LastModifiedDate] --  datetime
	,CONCAT('ENT', CASE 
					WHEN E1.EntityCategoryCode='O' THEN E1.EntityId 
					ELSE E2.EntityId 
					END)							AS [Source_npe5__Organization__c]  -- Source ID for look up to Account
	,CASE 
		WHEN E1.EntityCategoryCode='I' THEN E1.EntityId 
		ELSE E2.EntityId 
		END											AS [Source_npe5__Contact__c]  -- Source ID for look up to Contact
	,ER.Comment                                     AS [npe5__Description__c] --  ntext(8)
	,ER.EndDate                                     AS [npe5__EndDate__c] --  date
	,ER.BeginDate                                   AS [npe5__StartDate__c] --  date
	,CASE 
		WHEN ER.ActiveFlag=1 THEN 'Current' 
		ELSE 'Former' 
		END											AS [npe5__Status__c] --  nvarchar(255)
	,CASE 
		WHEN E1.EntityCategoryCode='I' THEN rRT1.RelationshipTypeName 
		ELSE rRT2.RelationshipTypeName 
		END											AS [Role__c] --  nvarchar(255)
FROM 
		tbl_Qualified_Entity AS qe with(nolock)
		LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
		ON QE.EntityId = ER.EntityId
	--JOIN SFIntegration.ct.ChangedEntityRelationshipIds as ChangeSet  with(nolock)
	--	ON ER.SF_UniqueKey = ChangeSet.SF_UniqueKey
		AND ER.RelationshipTypeId <> 477 -- "Not a Duplicate Account" relationships are excluded
		AND ER.EntityId <> ER.ReferencedEntityId -- relationships to self will not be migrated or integrated
	JOIN TommiQA1.dbo.apfx_refRelationshipType as rRT1  with(nolock)
		ON ER.RelationshipTypeId = rRT1.RelationshipTypeId
		AND rRT1.RelationshipCategoryId <> 11 --Exclude Portfolio Relationship Types (these will either not be migrated, or one-time migration without ongoing integration to Account Team)
	JOIN TommiQA1.dbo.apfx_refRelationshipType as rRT2  with(nolock)
		ON rRT1.ReciprocalRelationshipTypeId = rRT2.RelationshipTypeId
	JOIN TommiQA1.dbo.apfx_EntityRelationship AS ER2 with(nolock)
		ON ER.ReferencedEntityId = ER2.EntityId
		AND ER.EntityId = ER2.ReferencedEntityId
		AND rRT1.ReciprocalRelationshipTypeId = ER2.RelationshipTypeId
		--AND ER.SF_UniqueKey > ER2.SF_UniqueKey -- Migrate and integrate the latter of the two relationship records. Code within SF will create/update/delete a reciprocal
	JOIN TommiQA1.dbo.apfx_Entity as E1  with(nolock)
		ON ER.EntityId = E1.EntityId and E1.ActiveFlag = 1 --CRM-296 VP
	JOIN TommiQA1.dbo.apfx_Entity as E2  with(nolock)
		ON ER.ReferencedEntityId = E2.EntityId and E2.ActiveFlag = 1  --CRM-296 VP
	LEFT JOIN SFIntegration.dbo.XREF_Relationship as XR with(nolock)
		ON ER.SF_UniqueKey = XR.DWID
	LEFT JOIN SFIntegration.dbo.XREF_Affiliation as XA with(nolock)
		ON ER.SF_UniqueKey = XA.DWID
	Where
		XA.DWID is null AND XA.SFID IS NULL
		AND XR.DWID is null
		AND 
		(
				(E1.EntityCategoryCode='I' AND E2.EntityCategoryCode='O')
				OR
				(E1.EntityCategoryCode='O' AND E2.EntityCategoryCode='I')
			)
		AND (ER.ActiveFlag = 1 OR rRT1.RelationshipCategoryId IN (1, 2)) -- migrate only active relationships, except for Employee/Company and Exec/Company relations (which will also migrate inactive relationships)
		AND ER.RelationshipTypeId <> 477 -- "Not a Duplicate Account" relationships are excluded
		AND ER.EntityId <> ER.ReferencedEntityId -- relationships to self will not be migrated or integrated
GO


