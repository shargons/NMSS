
DROP TABLE [dbo].[tbl_Qualified_Entity]

SELECT ConstituentId as EntityId
INTO [CFG_NMSS_PROD].[dbo].[tbl_Qualified_Entity]
FROM [CFG_NMSS_PROD].[dbo].[NMSS_Navigator_Individuals]