USE [TommiQA1]
GO

/****** Object:  Index [NonClusteredIndex-20240229-123504]    Script Date: 2/29/2024 12:36:37 PM ******/
DROP INDEX [NonClusteredIndex-20240229-123504] ON [dbo].[apfx_EntityEmail]
GO

/****** Object:  Index [NonClusteredIndex-20240229-123504]    Script Date: 2/29/2024 12:36:37 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20240229-123504] ON [dbo].[apfx_EntityEmail]
(
	[EntityId] ASC,
	[PreferredEmailFlag] ASC,
	[ActiveFlag] ASC
)
INCLUDE([EmailDeliveryStatusCode],[EmailDeliveryStatusDateTime],[EmailStructureStatusCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


