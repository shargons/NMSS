USE CFG_NMSS_PROD;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Interest__c 
--====================================================================

-- Parent Interests 
--DROP table Interest__c_ResponseCategory_LOAD
SELECT [Id]
      ,[DWUI_Response_Type_ID__c]
      ,[Name]
      ,[CreatedDate]
      ,[LastModifiedDate]
      ,[OwnerId]
      ,[CreatedById]
      ,[LastModifiedById]
      ,[IsActive__c]
  INTO Interest__c_ResponseCategory_LOAD
  FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[vw_DW_CFG_ResponseCategory_Interest]
GO

/******* Check Load table *********/
SELECT *
FROM Interest__c_ResponseCategory_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Interest__c_ResponseCategory_LOAD
ALTER COLUMN ID NVARCHAR(18)


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PROD','Interest__c_ResponseCategory_LOAD'

SELECT * FROM Interest__c_ResponseCategory_LOAD_Result where Error ='Operation Successful.'

select DISTINCT Error from Interest__c_ResponseCategory_LOAD_Result

/******* Create Lookup Table *********/

--drop table Interest_ResponseCategory_Lookup
SELECT Id,[DWUI_Response_Type_ID__c] AS Data_Warehouse_ID__c
INTO Interest_ResponseCategory_Lookup
FROM Interest__c_ResponseCategory_LOAD_Result
where Error = 'Operation Successful.'

SELECT * FROM Interest_ResponseCategory_Lookup

/******* DBAmp Delete Script *********/
--DROP TABLE  Interest__c_DELETE
--DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
--EXECUTE sf_generate 'Delete',@_table_server, ' Interest__c_DELETE'

--SELECT ID INTO Interest__c_DELETE FROM Interest__c_ResponseCategory_LOAD_Result WHERE Error = 'Operation Successful.'

--DECLARE @_table_server	nvarchar(255) = DB_NAME()
--EXECUTE	SF_TableLoader
--		@operation		=	'Delete'
--,		@table_server	=	@_table_server
--,		@table_name		=	'Interest__c_DELETE'


