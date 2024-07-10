--DROP TABLE Case_LOAD_Rem
SELECT *
INTO [CFG_NMSS_PROD].dbo.Case_LOAD_Rem
FROM [NMSS_PRD].[CFG_NMSS_PROD].[dbo].[Case_LOAD_Rem] 

SELECT * FROM Case_LOAD_Rem

/******* Change ID Column to nvarchar(18) *********/
ALTER TABLE Case_LOAD_Rem
ALTER COLUMN ID NVARCHAR(18)

SELECT * FROM Case_LOAD_Rem_Result
WHERE Error <> 'Operation Successful.'


/******* DBAmp Insert Script *********/
EXEC SF_TableLoader 'Insert:BULKAPI','CFG_NMSS_PROD','Case_LOAD_Rem'

INSERT INTO [dbo].[Case_Lookup]
SELECT ID ,[Data_Warehouse_ID__c]
FROM [Case_LOAD_Rem_result]
where Error = 'Operation Successful.'
