USE [TommiQA1]
GO

/****** Object:  Index [NonClusteredIndex-20240229-121822]    Script Date: 2/29/2024 12:19:32 PM ******/
DROP INDEX [NC_EntityRelationship] ON [dbo].[apfx_EntityRelationship]
GO

/****** Object:  Index [NonClusteredIndex-20240229-121822]    Script Date: 2/29/2024 12:19:32 PM ******/
CREATE NONCLUSTERED INDEX [NC_EntityRelationship] ON [dbo].[apfx_EntityRelationship]
(
	[RelationshipTypeId] ASC
)
INCLUDE([PrimaryFlag],[QualityRatingId],[ConfirmedDateTime],[ActiveFlag],[CreatedDate],[UpdatedDate],[AuthorizedToDiscussFlag],[Comment],[BeginDate],[EndDate],[UpdatedUserId],[CreatedUserId],[SF_UniqueKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO


