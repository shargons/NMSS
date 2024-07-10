USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[NMSS_Navigator_Individuals]    Script Date: 5/8/2024 2:20:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [dbo].[NMSS_Navigator_Individuals] AS
select distinct ConstituentId
from [Tommiprd1].dbo.apfx_interaction i
join [Tommiprd1].dbo.apfx_interactiondetail id on i.interactionid = id.interactionid
left join [Tommiprd1].dbo.apfx_InteractionDetailResponseType rt on rt.interactiondetailid = id.interactiondetailid and rt.ActiveFlag = 1
left join [Tommiprd1].dbo.apfx_refResponseType rr on rt.ResponseTypeId = rr.ResponseTypeId
left join [Tommiprd1].dbo.apfx_refResponseCategory rc on rr.ResponseCategoryId = rc.ResponseCategoryId
left join [Tommiprd1].dbo.[apfx_InteractionDetailTrackedTopic] tt on tt.InteractionDetailId = id.InteractionDetailId
join [Tommiprd1].dbo.apfx_entity e on e.entityid = i.ConstituentId and e.ActiveFlag = 1 and entitycategorycode = 'I'
join [Tommiprd1].dbo.apfx_sysInteractionDetailType dt on dt.DetailTypeCode = id.DetailTypeCode
LEFT join sfintegration.[dbo].[XREF_Contact] xc on xc.DWID = i.constituentid
where xc.dwid is null
and i.interactioncategoryid in (59,61) --Strategy Area for Advocacy and Services
and (rc.ResponseCategoryId in (231,232,207,209,198,195,228) --These are the Tier 1 Response Categories used by Services
or tt.trackedtopicid is not null--This is necessary to get the Hot Topic Interactions
or id.DetailTypeCode in ('A','B', 'C', 'F', 'L', 'P', 'R')) --These are all the non-Tier 1 interaction categories
and i.InteractionUserId <> 0
and i.ActiveFlag = 1
and id.ActiveFlag = 1
and firstname is not null --exclude individuals where first name blank
and lastname not in ('Anonymous', ' ') --exclude individuals where lastname 'Anonymous' or blank
GO


