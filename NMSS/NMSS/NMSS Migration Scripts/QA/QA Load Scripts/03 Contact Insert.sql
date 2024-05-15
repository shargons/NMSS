
USE CFG_NMSS_PREPROD;

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================
--DROP TABLE IF EXISTS [dbo].[Contact_Indiv_LOAD];
--GO
SELECT C.*,HL.SFID as AccountID
INTO [CFG_NMSS_PREPROD].dbo.Contact_Indiv_LOAD
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Contact] C
LEFT JOIN [CFG_NMSS_PREPROD].[dbo].[XREF_Account_Household] HL
ON C.Source_AccountId = HL.DWID
WHERE HL.SFID IS NOT NULL

/******* Check Load table *********/
SELECT * FROM Contact_Indiv_LOAD

--====================================================================
--INSERTING DATA USING DBAMP - Individual
--====================================================================


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Contact_Indiv_LOAD
ALTER COLUMN ID NVARCHAR(18)


EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','Contact_Indiv_LOAD'

SELECT * FROM Contact_Indiv_LOAD_Result where Error = 'Operation Successful.'

select DISTINCT  Error from Contact_Indiv_LOAD_Result

--====================================================================
--ERROR RESOLUTION - Individual
--====================================================================

SELECT * FROM Contact_Indiv_LOAD_Result where Error <> 'Operation Successful.'

/******* DBAmp Delete Script *********/
DROP TABLE Contact_Indiv_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Contact_Indiv_DELETE'

INSERT INTO Contact_Indiv_DELETE(Id) SELECT Id FROM Contact_Indiv_LOAD_Result WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Contact_Indiv_DELETE'


--====================================================================
--POPULATING XREF TABLES- Individual
--====================================================================

INSERT INTO [CFG_NMSS_QA].[dbo].[XREF_Contact]
           ([SFID]
           ,[DWID]
           ,[SystemOfCreation]
           ,[LastActionTaken]
           ,[LastUpdatedTime]
           ,[ModifiedUser]
           ,[ModifiedDate])
SELECT
 ID AS SFID
,[Data_Warehouse_ID__c]
,'DW' --SystemOfCreation
,'I' --LastActionTaken
,getdate()--LastUpdatedtime
,'MigrationUser' --ModifiedUSer
,getdate()--ModifiedDate
FROM Contact_Indiv_LOAD_Result
WHERE Error = 'Operation Successful.'

-- Contact Lookup
DROP TABLE IF EXISTS [dbo].[Contact_Lookup];
GO
SELECT
 ID
,[Data_Warehouse_ID__c]
INTO [CFG_NMSS_QA].[dbo].[Contact_Lookup]
FROM Contact_Indiv_LOAD_Result
WHERE Error = 'Operation Successful.'