
USE CFG_NMSS_PROD;

--====================================================================
--	INSERTING DATA TO THE LOAD TABLE FROM THE VIEW - Individual
--====================================================================
--DROP TABLE IF EXISTS [dbo].[User_LOAD];
--GO
SELECT DISTINCT U.ID AS ID,
[Territory   Market] as Territory_Market__c,
[Territory  State] as Territory_State__c,
[General Responsibilities] AS General_Responsibilities__c
	INTO [CFG_NMSS_PROD].dbo.User_LOAD
FROM [CFG_NMSS_PROD].[dbo].[CatCUserUpload] C
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

SELECT * FROM User_LOAD


EXEC SF_TableLoader 'Update:soap,batchsize(1)','CFG_NMSS_PROD','User_LOAD'

select * from User_Load_Result

