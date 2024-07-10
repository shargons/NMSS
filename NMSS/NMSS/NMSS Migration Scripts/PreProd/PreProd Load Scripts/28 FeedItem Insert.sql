
USE CFG_NMSS_PREPROD;
--DROP table Case_LOAD

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - FeedItem
--====================================================================
--DROP TABLE IF EXISTS [dbo].[FeedItem_LOAD];
--GO

-- Tier 1

SELECT *
INTO [CFG_NMSS_PREPROD].dbo.FeedItem_T1_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FeedItem_Tier1] F

-- L Type
SELECT *
INTO [CFG_NMSS_PREPROD].dbo.FeedItem_LType_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FeedItem_LType]

-- P Type
SELECT *
INTO [CFG_NMSS_PREPROD].dbo.FeedItem_PType_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FeedItem_PType]

-- R Type
SELECT *
INTO [CFG_NMSS_PREPROD].dbo.FeedItem_RType_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_FeedItem_RType]


/******* Check Load table *********/
SELECT *
FROM FeedItem_T1_LOAD

SELECT *
FROM FeedItem_LType_LOAD

SELECT *
FROM FeedItem_RType_LOAD

SELECT *
FROM FeedItem_PType_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FeedItem_T1_LOAD
ALTER COLUMN ID NVARCHAR(18)

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FeedItem_LType_LOAD
ALTER COLUMN ID NVARCHAR(18)

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FeedItem_PType_LOAD
ALTER COLUMN ID NVARCHAR(18)

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE FeedItem_RType_LOAD
ALTER COLUMN ID NVARCHAR(18)
--====================================================================
--INSERTING DATA USING DBAMP - FeedItem
--====================================================================
-- Tier 1
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_T1_LOAD'

SELECT Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,Body  
INTO FeedItem_T1_LOAD_2
FROM FeedItem_T1_LOAD_Result where Error <> 'Operation Successful.'

select count(*), Error from FeedItem_T1_LOAD_2_Result GROUP BY Error

/***** Load Errored Records ******/
DROP TABLE FeedItem_Load_Err
SELECT DISTINCT Y.* 
INTO FeedItem_Load_Err
FROM 
(
	SELECT X.*,LEN(Body) as BodyLength
	FROM
	(
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				SUBSTRING(TRIM(Body),1,6000) as Body
            
			FROM
				FeedItem_T1_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 1...'+CHAR(10)+SUBSTRING(TRIM(Body),6001,6000) as Body
			FROM
				FeedItem_T1_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 2...'+CHAR(10)+SUBSTRING(TRIM(Body),12001,6000) as Body
			FROM
				FeedItem_T1_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 3...'+CHAR(10)+SUBSTRING(TRIM(Body),18001,6000) as Body
			FROM
				FeedItem_T1_LOAD_2

			)X
	)Y
	WHERE Y.BodyLength > 32

SELECT * FROM FeedItem_Load_Err
ORDER BY ParentId

	-- Tier 1 Errored Load
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_Load_Err'

select count(*), Error from FeedItem_Load_Err_Result GROUP BY Error

SELECT Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,Body  
INTO FeedItem_T1_LOAD_5
FROM FeedItem_Load_Err_3_Result where Error <> 'Operation Successful.'



-- L Type
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_LType_LOAD'

SELECT * FROM FeedItem_LType_LOAD_Result where Error <> 'Operation Successful.'

select count(*), Error from FeedItem_LType_LOAD_Result GROUP BY Error


-- P Type
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_PType_LOAD'

SELECT * FROM FeedItem_PType_LOAD_Result where Error <> 'Operation Successful.'

select count(*), Error from FeedItem_PType_LOAD_Result GROUP BY Error

-- R Type
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_RType_LOAD'

SELECT * 
INTO FeedItem_RType_LOAD_2
FROM FeedItem_RType_LOAD_Result where Error <> 'Operation Successful.'

select count(*), Error from FeedItem_RType_LOAD_Result GROUP BY Error

--DROP TABLE FeedItem_RType_Load_Err
SELECT DISTINCT Y.* 
INTO FeedItem_RType_Load_Err
FROM 
(
	SELECT X.*,LEN(Body) as BodyLength
	FROM
	(
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				SUBSTRING(TRIM(Body),1,6000) as Body
            
			FROM
				FeedItem_RType_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 1...'+CHAR(10)+SUBSTRING(TRIM(Body),6001,6000) as Body
			FROM
				FeedItem_RType_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 2...'+CHAR(10)+SUBSTRING(TRIM(Body),12001,6000) as Body
			FROM
				FeedItem_RType_LOAD_2
			UNION ALL
			SELECT
				Id,ParentID,CreatedById,CreatedDate,InsertedById,NetworkScope,Status,Type,Visibility,
				'Previous Comment Continued 3...'+CHAR(10)+SUBSTRING(TRIM(Body),18001,6000) as Body
			FROM
				FeedItem_RType_LOAD_2

			)X
	)Y
	WHERE Y.BodyLength > 32

SELECT * FROM FeedItem_RType_Load_Err
ORDER BY ParentId

	-- R Type Errored Load
/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PREPROD','FeedItem_RType_Load_Err'

select * from FeedItem_RType_Load_Err_Result where Error = 'Operation Successful.'
order by ParentId


--====================================================================
--ERROR RESOLUTION - FeedItem
--=====================================================

/******* DBAmp Delete Script *********/
DROP TABLE  FeedItem_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, ' FeedItem_DELETE'

 SELECT ID INTO FeedItem_DELETE FROM FeedItem_RType_Load_Err_Result where Error ='Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'FeedItem_DELETE'


