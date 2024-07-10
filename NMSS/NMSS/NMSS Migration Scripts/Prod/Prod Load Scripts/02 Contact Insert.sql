
USE CFG_NMSS_PROD;

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================
--DROP TABLE IF EXISTS [dbo].[Contact_Indiv_LOAD];
--GO
SELECT C.*,HL.SFID as AccountID
INTO [CFG_NMSS_PROD].dbo.Contact_Indiv_LOAD
FROM [CFG_NMSS_PROD].[dbo].[vw_DW_SFDC_Contact] C
LEFT JOIN [CFG_NMSS_PROD].[dbo].[XREF_Account_Household] HL
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


EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Contact_Indiv_LOAD'

SELECT * FROM Contact_Indiv_LOAD_Result where Error <> 'Operation Successful.'

select DISTINCT  Error from Contact_Indiv_LOAD_Result

--====================================================================
--ERROR RESOLUTION - Individual
--====================================================================

SELECT * 
--INTO Contact_Indiv_LOAD_2
FROM Contact_Indiv_LOAD_Result where Error <> 'Operation Successful.'

UPDATE Contact_Indiv_LOAD_2
SET Direct_Mail_Market__c = 'zzz_Ohio Valley'
WHERE Data_Warehouse_ID__c IN (91145028,91315505,95061250)

--INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST:Secondary Language: bad value for restricted picklist field: Native American:Secondary_Language__c --
UPDATE Contact_Indiv_LOAD_2
SET Secondary_Language__c = 'My language is not listed'
WHERE Data_Warehouse_ID__c IN (82156084,74327312)

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
-- DBAMP Tools Server
INSERT INTO [CFG_NMSS_PROD].[dbo].[XREF_Contact]
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

-- SFIntegration Server
INSERT INTO [NMSS_PRD].[SFINTEGRATION].[dbo].[XREF_Contact]
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
INTO [CFG_NMSS_PROD].[dbo].[Contact_Lookup]
FROM Contact_Indiv_LOAD_Result
WHERE Error = 'Operation Successful.'