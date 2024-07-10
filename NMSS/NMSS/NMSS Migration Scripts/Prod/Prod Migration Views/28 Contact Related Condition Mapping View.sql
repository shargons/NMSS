
USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_Contact_RelatedCondition]  

AS 
--- Related Demyelinating Disease/Disorder
SELECT A.EntityId,
CASE WHEN B.ClassificationValue = 'ADEM' THEN 'Acute Disseminated Encephalomyelitis (ADEM)'
	 WHEN B.ClassificationValue = 'ALEXANDERDISEASE' THEN 'Alexander Disease'
	 WHEN B.ClassificationValue = 'AUTOIMMNENCEPHALITIS' THEN 'Autoimmune Encephalitis'
	 WHEN B.ClassificationValue = 'BALOSDISEASE' THEN 'Balo’s Disease'
	 WHEN B.ClassificationValue = 'CHRONICRELAPINFLAMOPTNEUR' THEN 'Chronic Relapsing Inflammatory Optic Neuropathy (CRION)'
	 WHEN B.ClassificationValue = 'CIS' THEN 'Clinically Isolated Syndrome'
	 WHEN B.ClassificationValue = 'DEVIC' THEN 'Neuromyelitis Optica Spectrum Disorder (NMOSD) (Also called NMO or Devic’s Disease)'
	 WHEN B.ClassificationValue = 'DIFCERESCLER' THEN 'Schilder''s Disease (Diffuse Cerebral Sclerosis)'
	 WHEN B.ClassificationValue = 'DISSEMENCEPH' THEN 'Disseminated encephalomyelitis'
	 WHEN B.ClassificationValue = 'HAM' THEN 'HTLV-I Associated Myelopathy (HAM)'
	 WHEN B.ClassificationValue = 'IIDDNS' THEN 'IIDDNS'
	 WHEN B.ClassificationValue = 'MOGAD' THEN 'Myelin Oligodendrocyte Glycoprotein Antibody Disease (MOGAD)'
	 WHEN B.ClassificationValue = 'NERUMYEOPTICNMODEVIC' THEN 'Neuromyelitis Optica Spectrum Disorder (NMOSD) (Also called NMO or Devic’s Disease)'
	 WHEN B.ClassificationValue = 'NEUROSARCOIDOSIS' THEN 'Neurosarcoidosis'
	 WHEN B.ClassificationValue = 'NONCOVER' THEN 'NONCOVER'
	 WHEN B.ClassificationValue = 'STIFFPERSONSYND' THEN 'Stiff Person Syndrome'
	 WHEN B.ClassificationValue = 'TRAVERMYE' THEN 	'Transverse Myelitis'
	 ELSE 'Declines to answer'
	 END AS Related_Conditions__c
FROM  [TommiPrd1].[dbo].apfx_EntityClassificationValue A
 JOIN [TommiPrd1].[dbo].apfx_refClassificationValue B
ON A.ClassificationValueId = B.ClassificationValueId 
WHERE  A.ActiveFlag = 1 and A.ClassificationId = 924
