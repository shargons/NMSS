SELECT ConstituentKeyProcessId,STRING_AGG(Agg_TypeDesc,CHAR(10)+CHAR(10)) AS Comment_TypeDesc
FROM (
SELECT csv.ConstituentKeyProcessId,'Award Amount :'+CAST(csv.DollarAmount AS NVARCHAR)+char(10)
+'Spend Category :'+
CASE WHEN MAX(vt.KeyProcessValueTypeName) IN ('Aids for Daily Living','Assistive Technology Devices - High Tech','Auto Modification','Home Modification','Ramp','Reacher/Grabber','Stair Glide') THEN 'Access Mods'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Transportation') THEN 'Transportation'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Crisis/Emergency Service','Food and Dietary Supplements','Furnace','Furniture','Rent Mortgage and Utilities','Water Heater') THEN 'Critical Short Term Needs'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Prof. Individual Counseling - In Person','Prof. Individual Counseling - Phone') THEN 'Mental Health Support'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Air Conditioner','Cane','Commode','Cooling Garments','Crutches','DME Repair','Equipment Assistance','Gel Cushions','GrabBars','Hospital Bed','Lift Chair','Lift','Raised Toilet Seat','Rolling Shower Chair','Scooter Electric','Shower/TubBench','Tub Transfer Bench','Walk Aide','Walker','Walker with Wheels','Wheelchair Manual','Wheelchair Power') THEN 'DME'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Dental Assistance','Exercise/Recreation Therapy Fees or Supplies','Incontinence Supplies','Medications or Medical Care','MS Clinic Visit','Occupational Therapy','Physical Therapy','Rehab Evals/Services','Rehab Evals/Services') THEN 'Health and Wellness'
	  WHEN MAX(vt.KeyProcessValueTypeName) IN ('Adult Day Center/Care','Chore Services','Home Care','Independent Living','Respite Care Services') THEN 'Respite Services'
     ELSE 'Other' END
+char(10)+'Benefit Type :'+vt.KeyProcessValueTypeName
as Agg_TypeDesc
		FROM [TommiQA1].[dbo].apfx_ConstituentKeyProcessValue csv
		     JOIN [TommiQA1].[dbo].apfx_refKeyProcessValueType vt 
	on csv.KeyProcessValueTypeId = vt.KeyProcessValueTypeId
		WHERE vt.KeyProcessValueCategoryId = 2 
		group by csv.ConstituentKeyProcessId,csv.DollarAmount,vt.KeyProcessValueTypeName
	)Comment_Desc
GROUP BY ConstituentKeyProcessId