
USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_Contact_RelatedCondition]  

AS 
--- Related Demyelinating Disease/Disorder
SELECT A.EntityId,B.ClassificationValue
FROM  [TommiQA1].[dbo].apfx_EntityClassificationValue A
 JOIN [TommiQA1].[dbo].apfx_refClassificationValue B
ON A.ClassificationValueId = B.ClassificationValueId 
WHERE  A.ActiveFlag = 1 and A.ClassificationId = 924
