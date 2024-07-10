USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_CrisisInterventionDescription]  
AS

SELECT 
		Cx.ID
		, ISNULL(Cx.Description,'')+CHAR(10)+CHAR(10)+'DWUI Interaction Detail :'+ CAST(id.InteractionDetailId AS nvarchar)+CHAR(10)+CHAR(10)+'Crisis Intervention'+CHAR(10)+ISNULL(id.Comments,'')
			+CHAR(10)+ISNULL('Risk to Self Scale : '+ss.RiskToSelfScaleName,'')+CHAR(10)+ISNULL('Risk to Others Scale : '+os.RiskToOthersScaleName,'')+CHAR(10)+ISNULL('Abuse/Neglect : '+ms.MentalStatusRatingName,'') 
			+CHAR(10)+ISNULL('Plan & Actions Taken : '+id.AssessmentPlansAndActions,'')+CHAR(10)+ISNULL('Domestic Violence : '+rep.ReportableSituationName,'') as Description
		,id.RiskToSelfScaleId,ID.RiskToOthersScaleId,id.MentalStatusRatingId,AssessmentPlansAndActions,rs.ReportableSituationId,id.Comments
FROM TommiPrd1.dbo.apfx_Interaction I
	LEFT JOIN TommiPrd1.dbo.apfx_interactiondetail id 
			on i.interactionid = id.interactionid
	LEFT JOIN TommiPrd1.dbo.apfx_InteractionDetailReportableSituation rs
			on rs.InteractionDetailId = id.InteractionDetailId
	LEFT JOIN [CFG_NMSS_PROD].[dbo].[Case] Cx
		ON Cx.Data_Warehouse_ID__c = id.InteractionId
	LEFT JOIN TommiPrd1.dbo.apfx_refRiskToSelfScale ss
	    ON ss.RiskToSelfScaleId = id.RiskToSelfScaleId
	LEFT JOIN TommiPrd1.dbo.apfx_refRiskToOthersScale os
	    ON os.RiskToOthersScaleId = id.RiskToOthersScaleId
	LEFT JOIN TommiPrd1.dbo.apfx_refMentalStatusRating ms
	    ON ms.MentalStatusRatingId = id.MentalStatusRatingId
	LEFT JOIN TommiPrd1.dbo.apfx_refReportableSituation rep
	    ON rep.ReportableSituationId = rs.ReportableSituationId
WHERE 
I.ActiveFlag = 1 
and id.ActiveFlag = 1 AND 
Id.DetailTypeCode = 'A'
AND (ID.RiskToSelfScaleId IS NOT NULL 
	OR ID.RiskToOthersScaleId IS NOT NULL
	OR ID.MentalStatusRatingId IS NOT NULL 
	OR AssessmentPlansAndActions IS NOT NULL
	OR rs.ReportableSituationId IS NOT NULL
    OR id.Comments IS NOT NULL) 
and Cx.ID is not null
	