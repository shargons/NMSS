select * 
from [dbo].apfx_ConstituentKeyProcessStepValue 
where ConstituentKeyProcessId = 152637281

select * 
from [dbo].apfx_ConstituentKeyProcessValue 
where ConstituentKeyProcessId = 152637281

select * 
from [dbo].apfx_constituentkeyprocessstep 
where ConstituentKeyProcessId = 152637281

select * 
from [dbo].apfx_refKeyProcessValueType 
where KeyProcessValueTypeId IN (132,94)

select * 
from [dbo].apfx_ConstituentKeyProcessValue 
where KeyProcessValueTypeId IN (98,108)

select * 
from [dbo].apfx_refKeyProcessValueType 
where KeyProcessValueTypeId IN (114,132)

select * 
from [dbo].apfx_refkeyprocessstep 
where  StepCode = '6C'


select * 
from [dbo].apfx_sysKeyProcessValueCategory
where KeyProcessValueCategoryId IN (1,2)


select * 
from [dbo].apfx_refKeyProcessStatus

 
select *
from apfx_interaction i 
left join apfx_interactiondetail id on i.interactionid = id.interactionid 
left join apfx_InteractionDetailResponseType dr on id.InteractionId = dr.InteractionId 
left join apfx_refresponsetype rt on dr.responsetypeid = rt.responsetypeid 
left join apfx_refResponseCategory rc on rt.ResponseCategoryId = rc.responsecategoryid 
where i.constituentid = 48541601 
and id.interactionid = 155064049 
and i.activeflag =1  
and id.activeflag = 1 


--Financial Workflow (Case) 

select * 
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
left join apfx_refKeyProcessValueType vt on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
left join apfx_sysKeyProcessValueCategory vc on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
where 
--cp.ConstituentId = 54916559 -- completed
--and cp.InteractionId = 155064049 and -- completed
cp.ConstituentId = 41602022 
and cp.InteractionId = 152928867 and 
--cp.ConstituentId = 41853554 -- approved but not closed
--and cp.InteractionId = 152744407 and -- approved but not closed
--cp.ConstituentId = 41509763 -- survey sent
--and cp.InteractionId = 152858530 and -- survey sent
--cp.ConstituentId = 89351459 -- leveraged funds with 2 dollar amounts
--and cp.InteractionId = 152939908 and -- leveraged funds with 2 dollar amounts
 cs.ActiveFlag = 1 
 --and rk.StepCode = '6C' and VT.KeyProcessValueCategoryId IS NOT NULL
--and cp.CompleteFlag = 0
--and vc.KeyProcessValueCategoryId = 5
order by cs.constituentkeyprocessstepsequence 



-- Open FA Request Mapping

select DISTINCT KeyProcessStatusName,st.KeyProcessStatusId 
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
left join apfx_refKeyProcessValueType vt on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
left join apfx_sysKeyProcessValueCategory vc on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
where 
cs.ActiveFlag = 1 
and cp.CompleteFlag = 0
order by KeyProcessStatusId

-- Closed FA Request Mapping

select DISTINCT KeyProcessStatusName,st.KeyProcessStatusId 
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
left join apfx_refKeyProcessValueType vt on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
left join apfx_sysKeyProcessValueCategory vc on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
where 
cs.ActiveFlag = 1 
and cp.CompleteFlag = 1
order by KeyProcessStatusId
