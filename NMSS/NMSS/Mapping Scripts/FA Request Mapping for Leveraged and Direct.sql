SELECT * FROM apfx_ConstituentKeyProcessStepValue
WHERE ConstituentKeyProcessId = 152697064

SELECT * FROM apfx_ConstituentKeyProcessValue
WHERE ConstituentKeyProcessId = 152697064

SELECT * FROM apfx_refKeyProcessStep
WHERE KeyProcessStepId = 328

select cs.InteractionDetailId,rk.StepName,CP.ConstituentKeyProcessId,cs.KeyProcessStepId,vt.KeyProcessValueTypeName,vc.KeyProcessValueCategoryName,pv.DollarAmount from apfx_ConstituentKeyProcess cp
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
left join dbo.apfx_InteractionDetail id on id.InteractionDetailId = cs.InteractionDetailId
left join apfx_refKeyProcessValueType vt on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
left join apfx_sysKeyProcessValueCategory vc on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
where 
--cp.ConstituentId = 89679537 
--and cp.InteractionId = 155236020 and 
cs.ActiveFlag = 1 and id.DetailTypeCode = 'F' 
--AND cs.KeyProcessStepId = 328 
and vc.KeyProcessValueCategoryName = 'Leveraged Financial Benefit'
group by cs.InteractionDetailId,CP.ConstituentKeyProcessId,cs.KeyProcessStepId,vt.KeyProcessValueTypeName,vc.KeyProcessValueCategoryName,pv.DollarAmount,rk.StepName
order by cs.InteractionDetailId,cp.ConstituentKeyProcessId,cs.KeyProcessStepId


select cp.constituentkeyprocessid,MAX(StepCode),StepName,VendorName
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
where 
--cp.ConstituentId = 89679537 
--and cp.InteractionId = 155236020 and 
cs.ActiveFlag = 1 and CompleteFlag = 0
----and StepCode = '5'
--and Comments is not null
--AND CS.ConstituentKeyProcessId = 109373
GROUP BY cp.constituentkeyprocessid,StepName,VendorName



select *
from apfx_ConstituentKeyProcess cp 
join apfx_constituentkeyprocessstep cs on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
join apfx_refkeyprocessstep rk on cs.keyprocessstepid = rk.keyprocessstepid 
left join apfx_ConstituentKeyProcessStepValue sv on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
left join dbo.apfx_ConstituentKeyProcessValue pv on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
join apfx_secUser su on cs.createduserid = su.userid 
join apfx_refkeyprocessstatus st on cp.keyprocessstatusid = st.keyprocessstatusid 
where 
--cp.ConstituentId = 89679537 
--and cp.InteractionId = 155236020 and 
cs.ActiveFlag = 1 
----and StepCode = '5'
--and Comments is not null
AND CS.ConstituentKeyProcessId = 152637264

order by ConstituentId,cs.constituentkeyprocessstepsequence 
