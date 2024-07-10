
USE CFG_NMSS_PREPROD;

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================
--DROP TABLE IF EXISTS [dbo].[User_LOAD];
--GO
SELECT DISTINCT U.ID AS ID,
[Territory   Market] as Territory_Market__c,
[Territory  State] as Territory_State__c,
[General Responsibilities] AS General_Responsibilities__c
	--INTO [CFG_NMSS_PREPROD].dbo.User_LOAD
FROM [CFG_NMSS_PREPROD].[dbo].[vw_DW_CatCUserUpload] C
LEFT JOIN [User] U ON C.Name = U.Name
WHERE U.ID IS NOT NULL


/******* Check Load table *********/
SELECT * FROM User_LOAD

/******* Updates ***********/
update A
set Territory_State__c = NULL
FROM User_LOAD A
WHERE Territory_State__c LIKE ''

update A
set Territory_Market__c = NULL
FROM User_LOAD A
WHERE Territory_Market__c LIKE ''

update A
set General_Responsibilities__c = NULL
FROM User_LOAD A
WHERE General_Responsibilities__c LIKE ''


update A
set Territory_State__c = REPLACE(Territory_State__c,' DC','')
FROM User_LOAD A
WHERE Territory_State__c LIKE '%Washington DC%'

update A
set Territory_State__c = REPLACE(Territory_State__c,'Puerto Rico','')
FROM User_LOAD A
WHERE Territory_State__c LIKE '%Puerto Rico%'


--====================================================================
--INSERTING DATA USING DBAMP - Individual
--====================================================================


/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE User_LOAD
ALTER COLUMN ID NVARCHAR(18)


EXEC SF_TableLoader 'Update:BULKAPI2','CFG_NMSS_PREPROD','User_LOAD'


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
INSERT INTO [CFG_NMSS_PREPROD].[dbo].[XREF_Contact]
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
INSERT INTO [NMSS_SRC].[SFINTEGRATION].[dbo].[XREF_Contact]
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
INTO [CFG_NMSS_PREPROD].[dbo].[Contact_Lookup]
FROM Contact_Indiv_LOAD_Result
WHERE Error = 'Operation Successful.'