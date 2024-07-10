USE [CFG_NMSS_PROD]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CatCUserUpload]  

AS 

SELECT * FROM [dbo].[CatCUserUpload]