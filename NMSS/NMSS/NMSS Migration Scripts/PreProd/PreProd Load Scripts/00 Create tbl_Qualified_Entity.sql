
DROP TABLE [dbo].[tbl_Qualified_Entity]

SELECT ConstituentId as EntityId
INTO [dbo].[tbl_Qualified_Entity]
FROM [dbo].[NMSS_Navigator_Individuals]