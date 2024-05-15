USE CFG_NMSS_QA;


--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Interest__c 
--====================================================================


--DROP table Interest__c_LiteratureType_LOAD
SELECT 
	   I.[Id]
      ,I.[DWUI_Literature_Type_ID__c]
      ,[Name]
      ,[Source_cfg_Interests__ParentInterest__c]
	  ,RCL.ID AS ParentInterest__c
      ,[CreatedDate]
      ,[LastModifiedDate]
      ,[OwnerId]
      ,[CreatedById]
      ,[LastModifiedById]
	  ,[IsActive__c]
  INTO Interest__c_LiteratureType_LOAD
  FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_CFG_LiteratureType_Interest] I
  LEFT JOIN Interest_Lookup RCL 
  ON RCL.DWID = I.[Source_cfg_Interests__ParentInterest__c]
GO

/******* Check Load table *********/
SELECT *
FROM Interest__c_LiteratureType_LOAD

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Interest__c_LiteratureType_LOAD
ALTER COLUMN ID NVARCHAR(18)


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI2','CFG_NMSS_PREPROD','Interest__c_LiteratureType_LOAD'

SELECT * FROM Interest__c_LiteratureType_LOAD_Result where Error ='Operation Successful.'

select DISTINCT Error from Interest__c_LiteratureType_LOAD_Result

/******* Create Lookup Table *********/

--drop table Interest_ResourceType_Lookup
SELECT Id,DWUI_Literature_Type_ID__c AS Data_Warehouse_ID__c
INTO Interest_LiteratureType_Lookup
FROM Interest__c_LiteratureType_LOAD_Result
where Error = 'Operation Successful.'

SELECT * FROM Interest_LiteratureType_Lookup

/******* DBAmp Delete Script *********/
--DROP TABLE  Interest__c_DELETE
--@_table_server, ' Interest__c_DELETE'

--SELECT ID INTO Interest__c_DELETE FROM Interest__c_LiteratureType_LOAD_Result WHERE Error = 'Operation Successful.'

--DECLARE @_table_server	nvarchar(255) = DB_NAME()
--EXECUTE	SF_TableLoader
--		@operation		=	'Delete'
--,		@table_server	=	@_table_server
--,		@table_name		=	'Interest__c_DELETE'


