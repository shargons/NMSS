USE CFG_NMSS_PROD;

/*** Creating XREF tables in QA ***/

-- Account Org XRef Table
IF OBJECT_ID(N'dbo.XREF_Account_Org', N'U') IS NOT NULL  
   DROP TABLE [dbo].[XREF_Account_Org];  
GO

SELECT A.ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Account_Org]
FROM Account A
LEFT JOIN
Recordtype R
ON A.RecordTypeId = R.Id
WHERE R.DeveloperName = 'Organization'
AND Data_Warehouse_ID__c is NOT null

-- Account HH XRef Table
IF OBJECT_ID(N'dbo.XREF_Account_Household', N'U') IS NOT NULL  
   DROP TABLE [dbo].[XREF_Account_Household];  
GO

SELECT A.ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Account_Household]
FROM Account A
LEFT JOIN
Recordtype R
ON A.RecordTypeId = R.Id
WHERE R.DeveloperName = 'Household'

-- NMSS Navigator Individuals table to tbl_Qualified Entity
IF OBJECT_ID(N'dbo.tbl_Qualified_Entity', N'U') IS NOT NULL  
DROP TABLE [dbo].[tbl_Qualified_Entity];  
GO

SELECT ConstituentId AS EntityId 
INTO [CFG_NMSS_QA].dbo.tbl_Qualified_Entity
FROM [dbo].[NMSS_Navigator_Individuals]

USE [CFG_NMSS_QA]

GO

-- Create Non Clustered Index
CREATE NONCLUSTERED INDEX [NC_IX_ConstituentID] ON [dbo].[tbl_Qualified_Entity]
(
	[EntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

GO


-- Contact XRef Table
IF OBJECT_ID(N'dbo.XREF_Contact', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_Contact];  
GO

SELECT ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Contact]
FROM Contact


-- npe5__Affiliation__c XRef Table
IF OBJECT_ID(N'dbo.XREF_Affiliation', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_Affiliation];  
GO

SELECT ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Affiliation]
FROM npe5__Affiliation__c

-- Relationship XRef Table
IF OBJECT_ID(N'dbo.XREF_Relationship', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_Relationship];  
GO

SELECT ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Relationship]
FROM npe4__Relationship__c

-- Case XRef Table
IF OBJECT_ID(N'dbo.XREF_Case', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_Case];  
GO

SELECT ID as SFID,Data_Warehouse_ID__c AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_Case]
FROM [Case]

-- FARequest XRef Table
IF OBJECT_ID(N'dbo.XREF_FARequest', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_Case];  
GO

SELECT ID as SFID,[DWUI_Interaction_ID__c] AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_FARequest]
FROM FA_Request__c

IF OBJECT_ID(N'dbo.XREF_DW_SFDC_Warning__c', N'U') IS NOT NULL  
DROP TABLE [dbo].[XREF_DW_SFDC_Warning__c];  
GO

-- Warning XRef Table
SELECT ID as SFID,[Data_Warehouse_ID__c] AS DWID
,'DW' AS [SystemOfCreation]
,'I' AS [LastActionTaken]
,getdate() AS [LastUpdatedtime]
,'MigrationUser'AS [ModifiedUSer]
,getdate() AS [ModifiedDate]
INTO [dbo].[XREF_DW_SFDC_Warning__c]
FROM Warning__c
GO
