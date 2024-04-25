--====================================================================			
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW
--====================================================================
USE CFG_NMSS_QA;

/****** Create table from Mapping view ******/
DROP TABLE IF EXISTS [dbo].[Account_Affiliation_Organization_Insert];
GO
SELECT E.*
INTO [dbo].[Account_Affiliation_Organization_Insert]
FROM [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Account_org] E
INNER JOIN [NMSS_SRC].[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Affiliation] QA
ON QA.Source_npe5__Organization__c = E.[Data_Warehouse_ID__c]
ORDER BY E.[Data_Warehouse_ID__c]

/****** Alter table to add ID column ******/

ALTER TABLE [Account_Affiliation_Organization_Insert]
ALTER COLUMN ID nchar(18)


/****** Check Load table before Inserting ******/

SELECT * 
FROM [Account_Affiliation_Organization_Insert]


/****** DBAmp Insert Script ******/

--DECLARE @_table_server	nvarchar(255) = DB_NAME()
--EXECUTE	SF_TableLoader
--	@operation	=	'Insert:bulkapi2'
--	,@table_server	=	@_table_server
--	,@table_name	=	'Account_Organization_Insert'

EXEC SF_TableLoader 'Insert','CFG_NMSS_QA','Account_Affiliation_Organization_Insert'

/****** Error Handling ******/

SELECT *
FROM [dbo].[Account_Affiliation_Organization_Insert_Result]
WHERE Error = 'Operation Successful.'



/****** Create Lookup Table ******/
DROP TABLE IF EXISTS [dbo].[Account_Lookup];
GO
SELECT ID,Data_Warehouse_ID__c as LegacyID
INTO Account_Lookup
FROM Account_Organization_Insert_Result
WHERE Error = 'Operation Successful.'