USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Case]    Script Date: 3/26/2024 11:28:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE or ALTER VIEW [dbo].[vw_DW_CFG_FeedItem_LType]  
AS
SELECT
	NULL											AS [Id]
	,C.Id											AS [ParentId]
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	END												AS [CreatedById]
	,id.[CreatedDate]                               AS [CreatedDate]
	,0												AS [HasContent]
	,0											    AS [HasFeedEntity]
	,0												AS [HasLink]
	,0												AS [HasVerifiedComment]
	,CASE 
		WHEN UC.ID IS NULL THEN Us.ID
		ELSE UC.ID 
	END												AS [InsertedById]
	,0												AS [IsClosed]
    ,0												AS [IsDeleted]
    ,0												AS [IsRichText]
	,'AllNetworks'									AS [NetworkScope]
	,'Published'									AS [Status]
	,'TextPost'										AS [Type]
	,'InternalUsers'								AS [Visibility]
	,ID.DetailTypeCode
	, CASE 
		WHEN id.DetailTypeCode = '1' THEN 'DWUI Interaction Detail :' + CAST(id.InteractionDetailId AS nvarchar)+CHAR(10)+'Tier 1 Responses'+CHAR(10)+CHAR(10)+id.Comments
		WHEN id.DetailTypeCode = 'L' THEN 'DWUI Interaction Detail :' + CAST(id.InteractionDetailId AS nvarchar)+CHAR(10)+'Literature Fulfillment'+CHAR(10)+id.Comments
		WHEN id.DetailTypeCode = 'P' THEN 'DWUI Interaction Detail :' + CAST(id.InteractionDetailId AS nvarchar)+CHAR(10)+'Referrals to Society Programs'+CHAR(10)+id.Comments
		WHEN id.DetailTypeCode = 'R' THEN 'DWUI Interaction Detail :' + CAST(id.InteractionDetailId AS nvarchar)+CHAR(10)+'Service Provider Referral'+CHAR(10)+id.Comments
		END											AS [Body]
	--id.*
	FROM TommiQA1.dbo.apfx_Interaction I
	INNER JOIN [CFG_NMSS_QA].[dbo].[Case] C
		ON C.Data_Warehouse_ID__c = I.InteractionId
	JOIN TommiQA1.dbo.apfx_interactiondetail id 
		ON i.interactionid = id.interactionid
	LEFT JOIN [CFG_NMSS_QA].[dbo].[User] Us
			ON Us.Name = 'Migrations User'
	LEFT JOIN [CFG_NMSS_QA].[dbo].[vw_DW_CFG_User] UC
			ON id.CreatedUserId = UC.[Data_Warehouse_ID__c]
	WHERE id.DetailTypeCode in ('L')
	AND ID.Comments IS NOT NULL


