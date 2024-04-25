select * 
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
where 
cs.ActiveFlag = 1 and rk.KeyProcessId = 3 
--and cp.CompleteFlag = 0
--and cp.ConstituentId = 56039555
and cp.InteractionId = 111964767
order by cp.ConstituentKeyProcessId,cs.constituentkeyprocessstepsequence 

select * from apfx_Interaction
WHERE InteractionId = 111964767

