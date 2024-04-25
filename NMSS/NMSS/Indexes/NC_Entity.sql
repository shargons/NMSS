USE [TommiQA1]
GO

/****** Object:  Index [NC_Entity_ActiveFlag]    Script Date: 2/29/2024 12:24:41 PM ******/
DROP INDEX [NC_Entity_ActiveFlag] ON [dbo].[apfx_Entity]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [NC_Entity_ActiveFlag]    Script Date: 2/29/2024 12:24:41 PM ******/
CREATE NONCLUSTERED INDEX [NC_Entity_ActiveFlag] ON [dbo].[apfx_Entity]
(
	[ActiveFlag] ASC,
	[EntityCategoryCode] ASC
)
INCLUDE([AnonymousFlag],[CreatedDate],[UpdatedDate],[OrganizationName],[OrganizationURL],[OrganizationTypeCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


