
USE CFG_NMSS_QA;
--DROP table Case_LOAD

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FeedItem
--====================================================================
--DROP TABLE IF EXISTS [dbo].[FeedItem_LOAD];
--GO
SELECT *
INTO [CFG_NMSS_QA].dbo.FeedItem_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FeedItem] F


/******* Check Load table *********/
SELECT *
FROM FeedItem_LOAD

select * from FeedItem_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FeedItem_LOAD
ALTER COLUMN ID NVARCHAR(18)

--====================================================================
--INSERTING DATA USING DBAMP - FeedItem
--====================================================================

/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_QA','FeedItem_LOAD'

SELECT * FROM FeedItem_LOAD_Result where Error ='Operation Successful.'

select DISTINCT Error from FeedItem_LOAD_Result


--====================================================================
--ERROR RESOLUTION - FeedItem
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  FeedItem_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, ' FeedItem_DELETE'

SELECT ID INTO FeedItem_DELETE FROM FeedItem_LOAD_Result where Error ='Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FeedItem_DELETE'


