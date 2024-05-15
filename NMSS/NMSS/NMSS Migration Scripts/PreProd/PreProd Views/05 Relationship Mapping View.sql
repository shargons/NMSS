USE [CFG_NMSS_QA];
GO

/****** Object:  View [dbo].[vw_DW_SFDC_Relationship]    Script Date: 3/14/2024 11:38:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =====================================================
-- Author:       Traction
-- Create date: 
-- Description: 

-- Alter date: 2019-04-26
-- Description: changed the whole view(based on the comment on the ticket) and also ActiveFlag filter(CRM-226).
--
-- Alter date: 2019-05-14
-- Description: changed the whole view based on the ticket CRM-289.
--
-- Update by :	D. Sheriff
-- Update date : 7/28/2020
-- Description:	 Update relationship type name to new XRef table per CPS-130
-- ======================================================

--CREATE OR ALTER View [dbo].[vw_DW_SFDC_Relationship] AS

SELECT  
	XR.SFID						                    AS [Id] -- Salesforce ID 
	,ER.SF_UniqueKey                                AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
	,CASE 
		WHEN ER.UpdatedDate < ER.CreatedDate THEN ER.UpdatedDate 
		ELSE ER.CreatedDate 
		END											AS [CreatedDate] --  datetime
	,ER.UpdatedDate                                 AS [LastModifiedDate] --  datetime
	,ER.EntityId                                    AS [Source_npe4__Contact__c]  -- Source ID for look up to Contact
	,ER.Comment                                     AS [npe4__Description__c] --  ntext(8)
	,(
		SELECT r.SF_UniqueKey 
		FROM [TommiQA1].[dbo].apfx_EntityRelationship r 
		WHERE ER.ReferencedEntityId = r.EntityId
		AND ER.EntityId = r.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = r.RelationshipTypeId
	)												AS [Source_npe4__ReciprocalRelationship__c]  -- Source ID for look up to npe4__Relationship__c
	,ER.ReferencedEntityId                          AS [Source_npe4__RelatedContact__c]  -- Source ID for look up to Contact
	,CASE 
		WHEN ER.ActiveFlag = 1 THEN 'Current' 
		ELSE 'Former' 
		END											AS [npe4__Status__c] --  nvarchar(255)
--	,rRT.RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,XrRT.XREF_SF_RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,ER.AuthorizedToDiscussFlag                     AS [Authorized_to_Discuss__c] --  bit
FROM tbl_Qualified_Entity AS qe with(nolock)
	LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	ON qe.EntityId = ER.EntityId
	JOIN SFIntegration.ct.ChangedEntityRelationshipIds as ChangeSet  with(nolock)
		ON ER.SF_UniqueKey = ChangeSet.SF_UniqueKey
	JOIN TommiQA1.dbo.apfx_refRelationshipType AS rRT  with(nolock)
		ON ER.RelationshipTypeId = rRT.RelationshipTypeId
	JOIN [SFIntegration].dbo.XREF_RefRelationshipType  as XrRT
		on rRT.RelationshipTypeId = XrRT.Xref_RelationshipTypeID
	JOIN TommiQA1.dbo.apfx_EntityRelationship as ER2 with(nolock)
		ON ER.ReferencedEntityId = ER2.EntityId
		AND ER.EntityId = ER2.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = ER2.RelationshipTypeId
		AND ER.SF_UniqueKey > ER2.SF_UniqueKey -- Migrate and integrate the latter of the two relationship records. Code within SF will create/update/delete a reciprocal
	JOIN TommiQA1.dbo.apfx_Entity as E1  with(nolock)
		ON ER.EntityId = E1.EntityId
	JOIN TommiQA1.dbo.apfx_Entity as E2  with(nolock)
		ON ER.ReferencedEntityId = E2.EntityId
	LEFT JOIN [SFIntegration].dbo.XREF_Relationship as XR with(nolock)
		ON ER.SF_UniqueKey = cast(XR.DWID as int)
	LEFT JOIN SFIntegration.dbo.XREF_Affiliation as XA with(nolock)
		ON ER.SF_UniqueKey = cast(XA.DWID as int)
WHERE 
	XR.DWID is not null
UNION
SELECT  
	XR.SFID						                    AS [Id] -- Salesforce ID 
	,ER.SF_UniqueKey                                AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
	,CASE 
		WHEN ER.UpdatedDate < ER.CreatedDate THEN ER.UpdatedDate 
		ELSE ER.CreatedDate 
		END											AS [CreatedDate] --  datetime
	,ER.UpdatedDate                                 AS [LastModifiedDate] --  datetime
	,ER.EntityId                                    AS [Source_npe4__Contact__c]  -- Source ID for look up to Contact
	,ER.Comment                                     AS [npe4__Description__c] --  ntext(8)
	,(
		SELECT r.SF_UniqueKey 
		FROM [TommiQA1].[dbo].apfx_EntityRelationship r 
		WHERE ER.ReferencedEntityId = r.EntityId
		AND ER.EntityId = r.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = r.RelationshipTypeId
	)												AS [Source_npe4__ReciprocalRelationship__c]  -- Source ID for look up to npe4__Relationship__c
	,ER.ReferencedEntityId                          AS [Source_npe4__RelatedContact__c]  -- Source ID for look up to Contact
	,CASE 
		WHEN ER.ActiveFlag = 1 THEN 'Current' 
		ELSE 'Former' 
		END											AS [npe4__Status__c] --  nvarchar(255)
--	,rRT.RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,XrRT.XREF_SF_RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,ER.AuthorizedToDiscussFlag                     AS [Authorized_to_Discuss__c] --  bit
FROM tbl_Qualified_Entity AS qe with(nolock)
	LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	ON qe.EntityId = ER.EntityId
	JOIN SFIntegration.ct.ChangedEntityRelationshipIds as ChangeSet  with(nolock)
		ON ER.SF_UniqueKey = ChangeSet.SF_UniqueKey
		AND ER.RelationshipTypeId <> 477 -- "Not a Duplicate Account" relationships are excluded
		AND ER.EntityId <> ER.ReferencedEntityId -- relationships to self will not be migrated or integrated
	JOIN TommiQA1.dbo.apfx_refRelationshipType AS rRT  with(nolock)
		ON ER.RelationshipTypeId = rRT.RelationshipTypeId
		AND rRT.RelationshipCategoryId <> 11
	JOIN [SFIntegration].dbo.XREF_RefRelationshipType  as XrRT
		on rRT.RelationshipTypeId = XrRT.Xref_RelationshipTypeID
	JOIN TommiQA1.dbo.apfx_EntityRelationship as ER2 with(nolock)
		ON ER.ReferencedEntityId = ER2.EntityId
		AND ER.EntityId = ER2.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = ER2.RelationshipTypeId
		AND ER.SF_UniqueKey > ER2.SF_UniqueKey -- Migrate and integrate the latter of the two relationship records. Code within SF will create/update/delete a reciprocal
	JOIN TommiQA1.dbo.apfx_Entity as E1  with(nolock)
		ON ER.EntityId = E1.EntityId
	JOIN TommiQA1.dbo.apfx_Entity as E2  with(nolock)
		ON ER.ReferencedEntityId = E2.EntityId
	LEFT JOIN [SFIntegration].dbo.XREF_Relationship as XR with(nolock)
		ON ER.SF_UniqueKey = cast(XR.DWID as int)
	LEFT JOIN [SFIntegration].dbo.XREF_Affiliation as XA with(nolock)
		ON ER.SF_UniqueKey = cast(XA.DWID as int)
Where
		XA.DWID is null 
		AND XR.DWID is null
		AND E1.EntityCategoryCode = 'I' AND E1.ActiveFlag = 1 --active individual
		AND E2.EntityCategoryCode = 'I' AND E2.ActiveFlag = 1 --active individual
		AND (ER.ActiveFlag = 1 OR rRT.RelationshipCategoryId IN (1, 2)) -- migrate only active relationships, except for Employee/Company and Exec/Company relations (which will also migrate inactive relationships)
		AND ER.RelationshipTypeId <> 477 -- "Not a Duplicate Account" relationships are excluded
		AND ER.EntityId <> ER.ReferencedEntityId -- relationships to self will not be migrated or integrated
GO


