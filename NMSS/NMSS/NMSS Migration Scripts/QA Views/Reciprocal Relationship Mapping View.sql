USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Relationship]    Script Date: 3/5/2024 12:54:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [dbo].[vw_DW_CFG_ReciprocalRelationship]  
AS
SELECT
	NULL											AS [Id] -- Salesforce ID
	--XR.SFID						                    AS [Id] -- Salesforce ID 
	,r.SF_UniqueKey                                AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 
	,CASE 
		WHEN r.UpdatedDate < r.CreatedDate THEN r.UpdatedDate 
		ELSE r.CreatedDate 
		END											AS [CreatedDate] --  datetime
	,r.UpdatedDate                                 AS [LastModifiedDate] --  datetime
	,r.EntityId                                    AS [Source_npe4__Contact__c]  -- Source ID for look up to Contact
	,r.Comment                                     AS [npe4__Description__c] --  ntext(8)
	,ER.SF_UniqueKey							   AS [Source_npe4__ReciprocalRelationship__c]  -- Source ID for look up to npe4__Relationship__c
	,r.ReferencedEntityId                          AS [Source_npe4__RelatedContact__c]  -- Source ID for look up to Contact
	,CASE 
		WHEN r.ActiveFlag = 1 THEN 'Current' 
		ELSE 'Former' 
		END											AS [npe4__Status__c] --  nvarchar(255)
	--,rRT.RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,XrRT.XREF_SF_RelationshipTypeName                       AS [npe4__Type__c] --  nvarchar(255)
	,ISNULL(r.AuthorizedToDiscussFlag,0)                     AS [Authorized_to_Discuss__c] --  bit
FROM TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	--JOIN SFIntegration.ct.ChangedEntityRelationshipIds as ChangeSet  with(nolock)
	--	ON ER.SF_UniqueKey = ChangeSet.SF_UniqueKey
	JOIN TommiQA1.dbo.apfx_refRelationshipType AS rRT  with(nolock)
		ON ER.RelationshipTypeId = rRT.RelationshipTypeId
	JOIN SFIntegration.dbo.XREF_RefRelationshipType  as XrRT
		on rRT.ReciprocalRelationshipTypeId = XrRT.Xref_RelationshipTypeID
	JOIN TommiQA1.dbo.apfx_EntityRelationship as ER2 with(nolock)
		ON ER.ReferencedEntityId = ER2.EntityId
		AND ER.EntityId = ER2.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = ER2.RelationshipTypeId
		--AND ER.SF_UniqueKey > ER2.SF_UniqueKey -- Migrate and integrate the latter of the two relationship records. Code within SF will create/update/delete a reciprocal
	JOIN TommiQA1.dbo.apfx_Entity as E1  with(nolock)
		ON ER.EntityId = E1.EntityId
	JOIN TommiQA1.dbo.apfx_Entity as E2  with(nolock)
		ON ER.ReferencedEntityId = E2.EntityId
	JOIN [TommiQA1].[dbo].apfx_EntityRelationship r
	    ON ER.ReferencedEntityId = r.EntityId
		AND ER.EntityId = r.ReferencedEntityId
		AND rRT.ReciprocalRelationshipTypeId = r.RelationshipTypeId
	--LEFT JOIN SFIntegration.dbo.XREF_Relationship as XR with(nolock)
	--	ON ER.SF_UniqueKey = cast(XR.DWID as int)
	--LEFT JOIN SFIntegration.dbo.XREF_Affiliation as XA with(nolock)
	--	ON ER.SF_UniqueKey = cast(XA.DWID as int)


/** Only for QA **/
--INNER JOIN [CFG_NMSS_QA].[dbo].[QA_Individual_Contacts] I
--ON I.EntityId = ER.EntityId


Where
		--XA.DWID is null 
		--AND XR.DWID is null AND 
		E1.EntityCategoryCode = 'I' AND E1.ActiveFlag = 1 --active individual
		AND E2.EntityCategoryCode = 'I' AND E2.ActiveFlag = 1 --active individual
		AND (ER.ActiveFlag = 1 OR rRT.RelationshipCategoryId IN (1, 2)) -- migrate only active relationships, except for Employee/Company and Exec/Company relations (which will also migrate inactive relationships)
		AND ER.RelationshipTypeId <> 477 -- "Not a Duplicate Account" relationships are excluded
		AND ER.EntityId <> ER.ReferencedEntityId -- relationships to self will not be migrated or integrated
GO


