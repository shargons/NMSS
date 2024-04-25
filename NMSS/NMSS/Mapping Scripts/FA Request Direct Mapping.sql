SELECT * 
FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcess cp 
JOIN [TommiQA1].[dbo].apfx_constituentkeyprocessstep cs 
	on cp.constituentkeyprocessid = cs.constituentkeyprocessid 
JOIN [TommiQA1].[dbo].apfx_refkeyprocessstep rk 
	on cs.keyprocessstepid = rk.keyprocessstepid 
LEFT JOIN [TommiQA1].[dbo].apfx_ConstituentKeyProcessStepValue sv 
	on cp.constituentkeyprocessid = sv.constituentkeyprocessid and cs.keyprocessstepid = sv.keyprocessstepid and sv.ActiveFlag = 1 
LEFT JOIN [TommiQA1].[dbo].apfx_ConstituentKeyProcessValue pv 
	on cp.constituentkeyprocessid = pv.constituentkeyprocessid and cs.keyprocessstepid = pv.keyprocessstepid and pv.ActiveFlag = 1 
JOIN [TommiQA1].[dbo].apfx_secUser su 
	on cs.createduserid = su.userid 
JOIN [TommiQA1].[dbo].apfx_refkeyprocessstatus st 
	on cp.keyprocessstatusid = st.keyprocessstatusid 
LEFT JOIN [TommiQA1].[dbo].apfx_refKeyProcessValueType vt 
	on pv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
LEFT JOIN [TommiQA1].[dbo].apfx_sysKeyProcessValueCategory vc 
	on vt.KeyProcessValueCategoryId = vc.KeyProcessValueCategoryId
where  cs.ActiveFlag = 1 and vc.KeyProcessValueCategoryName <> 'Leveraged Financial Benefit' and cp.ConstituentKeyProcessId = 152620518

select string_agg(CS.Comments,char(10)) FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcess cp 
JOIN [TommiQA1].[dbo].apfx_constituentkeyprocessstep cs  on cp.constituentkeyprocessid = cs.constituentkeyprocessid  
JOIN [TommiQA1].[dbo].apfx_refkeyprocessstep rk 
	on cs.keyprocessstepid = rk.keyprocessstepid 
where cp.ConstituentKeyProcessId = 152620518

select * from apfx_refKeyProcessValueType


