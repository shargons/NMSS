
USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_Contact_DocDiagnosisDate]  

AS 
--- Documentation of Diagnosis Date
SELECT A.EntityId,A.CreatedDate AS Documentation_of_Diagnosis_Date__c
FROM  [TommiPrd1].[dbo].apfx_EntityClassificationValue A
 JOIN [TommiPrd1].[dbo].apfx_refClassificationValue B
ON A.ClassificationValueId = B.ClassificationValueId 
WHERE  A.ActiveFlag = 1 and A.ClassificationId = 923
