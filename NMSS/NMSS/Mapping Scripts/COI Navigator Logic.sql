select i.constituentid, e.firstname, e.lastname, i.interactiondatetime, i.interactioncategoryid, i.interactionid, id.interactiondetailid, id.detailtypecode, dt.DetailTypeDesc, rc.ResponseCategoryId, ResponseCategoryName, i.Description as 'CatC Subject', i.comments as 'CatC Description'
from apfx_interaction i
join apfx_interactiondetail id on i.interactionid = id.interactionid
left join apfx_InteractionDetailResponseType rt on rt.interactiondetailid = id.interactiondetailid and rt.ActiveFlag = 1
left join apfx_refResponseType rr on rt.ResponseTypeId = rr.ResponseTypeId
left join apfx_refResponseCategory rc on rr.ResponseCategoryId = rc.ResponseCategoryId and rc.ResponseCategoryId in (231,232,207,209,198,195,228)
join apfx_entity e on e.entityid = i.ConstituentId and e.ActiveFlag = 1 and entitycategorycode = 'I'
join apfx_sysInteractionDetailType dt on dt.DetailTypeCode = id.DetailTypeCode
and i.interactioncategoryid in (59,61) --Strategy Area for Advocacy and Services
and (id.ResponseTypeId = 634 --This is necessary to get the Hot Topic Interactions
or id.DetailTypeCode in ('A','B', 'C', 'F', 'L', 'P', 'R')) --These are all the non-Tier 1 interaction categories
and i.InteractionUserId <> 0
and i.ActiveFlag = 1
and id.ActiveFlag = 1
and firstname is not null --exclude individuals where first name blank
and lastname not in ('Anonymous', ' ') --exclude individuals where lastname 'Anonymous' or blank
and id.DetailTypeCode = '1'

-- 206,208,210,211,213,214,216,224,225,226,233