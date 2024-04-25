USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_CFG_Relationship]    Script Date: 3/5/2024 12:54:07 PM ******/
/****** Reciprocal is created automatically - Do Not Create Reciprocal ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [vw_DW_CFG_User] AS
SELECT 
	SFU.Id																   AS [Id] -- Salesforce ID
	,SUBSTRING(U.FirstName,1,1) + SUBSTRING(U.LastName,1,4)                AS [Alias] -- nvarchar(8)
	,'US'																   AS [CountryCode] -- nvarchar(255)
	,'United States of America'											   AS [Country] -- nvarchar(80)
	,U.UserId															   AS [Data_Warehouse_ID__c] -- nvarchar(120)
	,U.UserName+'.invalid'												   AS [Email] -- nvarchar(128)
	,U.FirstName														   AS [FirstName] -- nvarchar(40)
	,U.ActiveFlag														   AS [IsActive] -- bit
	,'en_US'														       AS [LanguageLocaleKey] -- nvarchar(255)
	,U.LastName															   AS [LastName] -- nvarchar(40)
	,'en_US'														       AS [LocaleSidKey] -- nvarchar(255)
	,U.FirstName+' '+U.LastName											   AS [Name] -- nvarchar(121)
	,P.ID																   AS [ProfileId] -- nvarchar(18)
	,U.UserName+'.cfgqa'												   AS [Username] -- nvarchar(18)
	,UR.ID																   AS [UserRoleId] --nvarchar(18)
	,'Standard'															   AS [UserType]
FROM 
TommiQA1.dbo.apfx_secUser U
	LEFT JOIN [TommiQA1].[dbo].[apfx_secUserRole] R ON U.UserId = R.UserId
	LEFT JOIN [CFG_NMSS_QA].[dbo].[User] SFU ON REPLACE(SFU.Username,'.cfgqa','') = U.UserName
	LEFT JOIN [CFG_NMSS_QA].[dbo].[Profile] P ON P.Name = 'Navigator'
	LEFT JOIN [CFG_NMSS_QA].[dbo].[UserRole] UR ON UR.DeveloperName = 'MS_Navigator_Standard'
WHERE R.RoleId = 21 
		AND U.ActiveFlag = 1 


