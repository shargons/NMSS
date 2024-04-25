USE [TommiQA1]
GO

/****** Object:  Index [NC_EntityPhone_ActiveFlag]    Script Date: 2/29/2024 12:26:28 PM ******/
DROP INDEX [NC_EntityPhone_ActiveFlag] ON [dbo].[apfx_EntityPhone]
GO

/****** Object:  Index [NC_EntityPhone_ActiveFlag]    Script Date: 2/29/2024 12:26:28 PM ******/
CREATE NONCLUSTERED INDEX [NC_EntityPhone_ActiveFlag] ON [dbo].[apfx_EntityPhone]
(
	[PhoneId] ASC,
	[EntityId] ASC
)
INCLUDE([ActiveFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


