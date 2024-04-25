USE [CFG_NMSS_QA]
GO

/****** Object:  View [dbo].[vw_DW_SFDC_Contact]    Script Date: 21/2/2024 2:19:09 PM  Author: Sharon Gonsalves ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER VIEW [vw_DW_SFDC_Account_org] AS	
SELECT 
	XREF.SFID										AS [Id] -- Salesforce ID
,	CONCAT('ENT', E.EntityId)							AS Data_Warehouse_ID__c
,	E.AnonymousFlag								AS Anonymous__c
,	E.ActiveFlag									AS Active__c
,   CASE 
	WHEN E.CreatedDate<E.UpdatedDate THEN E.CreatedDate 
	ELSE E.UpdatedDate 
	END											AS [CreatedDate] --  datetime
,	E.OrganizationName								AS Name
,	E.OrganizationURL											AS Website
,	rOC.OrganizationCategoryName                   AS [Type] --  nvarchar(40)
,	RT.Id                                          AS [RecordTypeId]  -- Source ID for look up to RecordType
,	rOT.OrganizationTypeName                       AS [Sub_Type__c] --  nvarchar(255)
,	E.MatchingContributionFlag						AS [npsp__Matching_Gift_Company__c]
,   CASE WHEN E.ServiceProviderFlag = 1 and SP.ActiveFlag = 1 THEN 1 ELSE 0 END AS [Service_Provider__c]
,   NULLIF(concat(A.AddressLine1, CHAR(13)+CHAR(10)+NULLIF(A.AddressLine2,''), CHAR(13)+CHAR(10)+NULLIF(A.AddressLine3,'')),'')  AS [ShippingStreet] --  ntext(8)
,   A.City                                         AS [ShippingCity] --  nvarchar(40)
,   rSP.StateProvinceName                          AS [ShippingState] --  nvarchar(80)
,   A.PostalCode                                   AS [ShippingPostalCode] --  nvarchar(20)
,   rC.CountryName                                 AS [ShippingCountry] --  nvarchar(80)
,   A.Latitude                                     AS [ShippingLatitude] --  float
,   A.Longitude                                    AS [ShippingLongitude] --  float
,   pPrimary.PhoneNumber                           AS [Phone] --  nvarchar(40)
,   pFax.PhoneNumber                               AS [Fax] --  nvarchar(40)
,   C_local.ChapterName                            AS [Market__c] --  nvarchar(255)
,   C_dm.ChapterName                               AS [Direct_Mail_Market__c] --  nvarchar(255)
--DREF-9 -- CASE Statement to invert values for SF conversion
,   CASE WHEN prefs.Mail = 0 THEN 1
         WHEN prefs.Mail = 1 THEN 0
		 ELSE 0 END                             AS [Postal_Opt_Out__c] -- bit
,   CASE WHEN prefs.Email = 0 THEN 1
         WHEN prefs.Email = 1 THEN 0
		 ELSE 0 END                             AS [HasOptedOutOfEmail] -- bit
,   CASE WHEN prefs.Phone = 0 THEN 1 
         WHEN prefs.Phone = 1 THEN 0
		 ELSE 0 END                             AS [DoNotCall] -- bit
,   CASE WHEN prefs.[Mobile Messaging] = 0 THEN 1
         WHEN prefs.[Mobile Messaging] = 1 THEN 0
		 ELSE 0 END                             AS [et4ae5__HasOptedOutOfMobile__c]-- bit
,  CASE WHEN (SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-QA' OR SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-qa%' ) and E.ServiceProviderFlag = 1 and sp.ServiceProviderId is not null 
		THEN CONCAT('https://dwuiqa.nmss.org/serviceprovider/editintakeform?serviceProviderId=',ServiceProviderId) 
		WHEN (SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-PR' OR SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-prod%' ) and E.ServiceProviderFlag = 1 and sp.ServiceProviderId is not null
		THEN CONCAT('https://dwuiprod.nmss.org/serviceprovider/editintakeform?serviceProviderId=',ServiceProviderId) ELSE NULL END AS [Link_to_DWUI_Service_Provider__c]
,	CASE WHEN A.StandardizedFlag is null THEN 0 ELSE A.StandardizedFlag END		AS [StandardizedFlag__c]
,	CASE WHEN A.DoNotStandardizeFlag is null THEN 0 ELSE A.DoNotStandardizeFlag END		AS [DoNotStandardizeFlag__c]
FROM 
TommiQA1.dbo.apfx_Entity E
/*** Migrate only from NMSS Navigator Organization list **/
--[CFG_NMSS_QA].[dbo].[NMSS_Navigator_Organizations] Nav
--INNER JOIN TommiQA1.dbo.apfx_Entity E 
--		ON Nav.[ConstituentId] = E.EntityId
LEFT JOIN [SFIntegration].[dbo].[vw_NMSS_help_Account_Global_Preferences] prefs
       ON prefs.Data_Warehouse_ID__c = E.EntityId
LEFT JOIN [SFIntegration].[dbo].[vw_NMSS_help_ServiceProviders] sp
       ON sp.EntityId = e.EntityId
LEFT JOIN [CFG_NMSS_QA].dbo.RecordType AS RT  with (nolock)
	ON RT.Name='Organization' AND RT.sObjectType='Account'
LEFT JOIN [TommiQA1].[dbo].apfx_refOrganizationType AS rOT  with (nolock)
	ON E.OrganizationTypeCode = rOT.OrganizationTypeCode
LEFT JOIN [TommiQA1].[dbo].apfx_refOrganizationCategory AS rOC  with (nolock)
	ON rOC.OrganizationCategoryCode = rOT.OrganizationCategoryCode
LEFT JOIN [TommiQA1].[dbo].apfx_EntityAddress AS EA  with (nolock)
	ON EA.EntityId = E.EntityId AND EA.ActiveFlag = 1 AND EA.PrimaryFlag = 1
LEFT JOIN [TommiQA1].[dbo].apfx_Address AS A  with (nolock)
	ON A.AddressId = EA.AddressId
LEFT JOIN [TommiQA1].[dbo].apfx_refStateProvince AS rSP  with (nolock)
	ON rSP.StateProvinceId = A.StateProvinceId AND rSP.CountryId = A.CountryId
LEFT JOIN [TommiQA1].[dbo].apfx_refCountry AS rC  with (nolock)
	ON rC.CountryId = A.CountryId
LEFT JOIN [SFIntegration].[dbo].vw_TRAC_help_PrimaryPhone AS pPrimary  with (nolock)
	ON pPrimary.EntityId = E.EntityId
LEFT JOIN [SFIntegration].[dbo].vw_TRAC_help_FaxPhone AS pFax  with (nolock)
	ON pFax.EntityId = E.EntityId
LEFT JOIN [TommiQA1].[dbo].apfx_Chapter AS C_local  with (nolock)
	ON C_local.ChapterCode = E.LocalChapterCode
LEFT JOIN [TommiQA1].[dbo].apfx_Chapter AS C_dm  with (nolock)
	ON C_dm.ChapterCode = E.DirectMailChapterCode
-- XREF table 
LEFT JOIN [CFG_NMSS_QA].dbo.XREF_Account_Org as xref with (nolock)
ON XREF.DWID =  CONCAT('ENT', E.EntityId)
/*** Use to migrate Affiliated Organizations **/
--INNER JOIN [CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Affiliation] QA
--ON REPLACE(QA.Source_npe5__Organization__c,'ENT','') = E.EntityId

WHERE E.EntityCategoryCode = 'O' 
--AND AL.ID IS NULL
AND E.ActiveFlag = 1
-- XREF table (Only use for PreProd/Full migration)
AND XREF.DWID is null






