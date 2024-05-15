select * 
from apfx_interaction i 
join apfx_interactiondetail id on i.interactionid = id.interactionid 
join apfx_InteractionDetailProviderReferral pr on id.interactiondetailid = pr.interactiondetailid 
join apfx_refresourcetype rt on pr.resourcetypeid = rt.resourcetypeid 
join apfx_refResourceCategory rc on rt.resourcecategoryid = rc.resourcecategoryid 
where id.interactiondetailid = 155172727 



select * 
from apfx_interaction i 
join apfx_interactiondetail id on i.interactionid = id.interactionid 
join apfx_InteractionDetailTrackedTopic tt on id.interactiondetailid = tt.interactiondetailid 
join apfx_refTrackedTopic rt on tt.trackedtopicid = rt.trackedtopicid 
where i.interactioncategoryid in (59,61) 

select id.detailtypecode, i.InteractionDateTime, i.interactionid, id.interactiondetailid, responsecategoryname, responsetypename, id.comments 
from apfx_interaction i 
join apfx_interactiondetail id on i.interactionid = id.interactionid 
join apfx_InteractionDetailResponseType dr on id.InteractionId = dr.InteractionId 
join apfx_refresponsetype rt on dr.responsetypeid = rt.responsetypeid 
join apfx_refResponseCategory rc on rt.ResponseCategoryId = rc.responsecategoryid 
where i.constituentid = 89679537 
and id.interactionid = 155214556 
and i.activeflag =1  
and id.activeflag = 1 