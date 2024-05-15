--====================================================================			
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW
--====================================================================
USE CFG_NMSS_QA;

/****** Create table from Mapping view ******/
DROP TABLE IF EXISTS [dbo].[Contact_Affiliations_Insert];
SELECT C.*,al.ID as AccountID
INTO [dbo].[Contact_Affiliations_Insert]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Contact] C
INNER JOIN
[NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Affiliation] A
ON C.[Data_Warehouse_ID__c] = A.[Source_npe5__Contact__c]
LEFT JOIN
[CFG_NMSS_QA].dbo.Account_HH_Lookup al
ON al.Data_Warehouse_ID__c = C.Source_AccountID

SELECT * FROM [dbo].[Contact_Affiliations_Insert]

/****** Alter table to add ID column ******/

ALTER TABLE [Contact_Affiliations_Insert]
ALTER COLUMN ID nchar(18)


/****** Check Load table before Inserting ******/

SELECT * 
FROM Contact_Affiliations_Insert



/****** DBAmp Insert Script ******/

--DECLARE @_table_server	nvarchar(255) = DB_NAME()
--EXECUTE	SF_TableLoader
--	@operation	=	'Insert:bulkapi2'
--	,@table_server	=	@_table_server
--	,@table_name	=	'Account_Organization_Insert'

EXEC SF_TableLoader 'Insert','CFG_NMSS_QA','Contact_Affiliations_Insert'

/****** Error Handling ******/

SELECT *
FROM [dbo].[Contact_Affiliations_Insert_Result]
WHERE Error <> 'Operation Successful.'


/******* DBAmp Delete Script *********/
DROP TABLE Contact_Affiliations_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Contact_Affiliations_DELETE'

INSERT INTO Contact_Affiliations_DELETE(Id) SELECT Id FROM [Contact_Affiliations_Insert_Result] WHERE Error = 'Operation Successful.'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Contact_Affiliations_DELETE'

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
FROM [Contact_Affiliations_Insert_Result]
WHERE Error = 'Operation Successful.'

/****** Create Lookup Table ******/

INSERT INTO [Contact_Lookup] 
SELECT ID,Data_Warehouse_ID__c as LegacyID
FROM Contact_Affiliations_Insert_Result
WHERE Error = 'Operation Successful.'