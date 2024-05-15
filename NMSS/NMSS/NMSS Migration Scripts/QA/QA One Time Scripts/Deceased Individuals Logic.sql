SELECT i.ConstituentId,E.DeceasedFlag,ER.SF_UniqueKey FROM [dbo].[NMSS_Navigator_Individuals] I
INNER JOIN
[TommiQA1].dbo.apfx_Entity E
ON I.ConstituentId = E.EntityId
LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	ON E.EntityId = ER.EntityId
where DeceasedFlag = 1 AND ER.SF_UniqueKey IS NOT NULL


SELECT i.ConstituentId,E.DeceasedFlag,ER.SF_UniqueKey FROM [dbo].[NMSS_Navigator_Individuals] I
INNER JOIN
[TommiQA1].dbo.apfx_Entity E
ON I.ConstituentId = E.EntityId
LEFT JOIN TommiQA1.dbo.apfx_EntityRelationship as ER with(nolock)
	ON E.EntityId = ER.EntityId
where DeceasedFlag = 1 AND ER.SF_UniqueKey IS NOT NULL

select count(*) from [TommiQA1].dbo.apfx_Entity E where DeceasedFlag = 1 AND E.EntityCategoryCode = 'I'


select count(*) FROM [dbo].[NMSS_Navigator_Individuals] I
INNER JOIN
[TommiQA1].dbo.apfx_Entity E
ON I.ConstituentId = E.EntityId
where DeceasedFlag = 1 