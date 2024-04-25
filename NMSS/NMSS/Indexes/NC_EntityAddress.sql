USE [TommiQA1]
GO

/****** Object:  Index [NC-EntityAddress_ActiveFlag]    Script Date: 2/29/2024 12:34:42 PM ******/
DROP INDEX [NC-EntityAddress_ActiveFlag] ON [dbo].[apfx_EntityAddress]
GO

/****** Object:  Index [NC-EntityAddress_ActiveFlag]    Script Date: 2/29/2024 12:34:42 PM ******/
CREATE NONCLUSTERED INDEX [NC-EntityAddress_ActiveFlag] ON [dbo].[apfx_EntityAddress]
(
	[EntityId] ASC,
	[PrimaryFlag] ASC
)
INCLUDE([ActiveFlag],[AddressId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


