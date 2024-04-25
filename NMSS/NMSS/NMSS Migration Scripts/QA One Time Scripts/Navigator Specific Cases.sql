select  I.*
from apfx_interaction i
join apfx_interactiondetail id on i.interactionid = id.interactionid
left join apfx_InteractionDetailResponseType rt on rt.interactiondetailid = id.interactiondetailid and rt.ActiveFlag = 1
left join apfx_refResponseType rr on rt.ResponseTypeId = rr.ResponseTypeId
left join apfx_refResponseCategory rc on rr.ResponseCategoryId = rc.ResponseCategoryId
join apfx_sysInteractionDetailType dt on dt.DetailTypeCode = id.DetailTypeCode
where i.interactioncategoryid in (59,61) --Strategy Area for Advocacy and Services
and (rc.ResponseCategoryId in (232,207,209,198,195,228) --These are the Tier 1 Response Categories used by Services
or id.ResponseTypeId = 634 --This is necessary to get the Hot Topic Interactions
or id.DetailTypeCode in ('A','B', 'C', 'F', 'L', 'P', 'R')) --These are all the non-Tier 1 interaction categories
and i.ActiveFlag = 1
and id.ActiveFlag = 1