USE [CFG_NMSS_QA];

/****** Object:  View [dbo].[vw_DW_SFDC_Contact]    Script Date: 2/22/2024 12:52:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







/*
--- ****************************************************************************************************** ---
--- ****************************************************************************************************** ---
--- ****************************************************************************************************** ---
---							READ THIS COMMENT BLOCK BEFORE DEPLOYING!!!!!!!								   ---
--- ****************************************************************************************************** ---
---																										   ---
---				THIS PROC CONTAINS AN ENVIRONMENT VARIABLE WHICH MUST BE UPDATED						   ---
---				PRIOR TO DEPLOYMENT.  '.FULL' MUST BE REMOVED											   ---
---																										   ---
--- ****************************************************************************************************** ---
---							READ THIS COMMENT BLOCK BEFORE DEPLOYING!!!!!!!								   ---
--- ****************************************************************************************************** ---
--- ****************************************************************************************************** ---
--- ****************************************************************************************************** ---


   Author                      :  Jhansi M
   Dell Boomi Process names    :  DW_SFDC_Constituents_Contact, SFDC_DW_Constituents_Contact
   Integration Type            :  Bi-Directional Edit
   DW to SFDC View name        :  [dbo].[DW_SFDC_Contact]
   DW to SFDC ToIntegrate Table:  [dbo].[DW_SFDC_Contact_ToIntegrate]
   XREF Table                  :  [dbo].[XREF_Contact]
   DW to SFDC Stored procedure :  [dbo].[sp_DW_SFDC_Contact]
   SFDC to DW stored  procedure:
   SFDC to DW ForImport Table  :  [dbo].[SFDC_DW_Contact_ForImport] 

-- Alter by :	Thiago Ferraz
-- Alter date: 2019-04-04
-- Description: Added the Qualified_entity condition(NMSSI-582) and also removed the SSIS User filter(NMSSI-584).
-- =============================================
-- Alter by :	Thiago Ferraz
-- Alter date: 2019-04-05
-- Description: removed the OwnerID field(NMSSI-570).
-- =============================================
-- Alter by :	Thiago Ferraz
-- Alter date: 2019-04-30
-- Description: use tbl_Qualified_Entity as the base table instead of the Entity tracking table per CRM-166.
-- =============================================
-- Alter by :	Thiago Ferraz
-- Alter date: 2019-05-08
-- Description:	Removed the Retire_flag field from the Mapping in Migration and Integration - CRM-179
-- =============================================
-- Alter by :	Thiago Ferraz
-- Alter date: 2019-05-09
-- Description: Update to be able to handle all DW MDM update scenarios per CRM-231.
-- =============================================
-- Alter by :	Vinnie Pisaniello
-- Alter date: 2020-03-19
-- Description: DREF-9: Sync Global Preferences.
-- =============================================
-- Author:			Vinnie Pisaniello
-- Updated date:	2020-03-27
-- Description:		DREF-56: Added Bad Email Ind
-- ======================================================
-- Author:			Vinnie Pisaniello
-- Updated date:	2020-09-28
-- Description:		COE-67: Added CountyName
-- ======================================================
-- Author: Vinnie Pisaniello
-- Alter date: 2021 - 12-02
-- Description: TD-1179 - Add Standardized and DoNotStandardize Flags to SF
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 2023 - 04-27
-- Description: DWUI-41 - Change Constituent Health Coverage to new multiselect
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 2023 - 07-24
-- Description: DWUI-51 - Change Constituent Race / Ethnicity to new multiselect
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 2023 - 12-01
-- Description: DWUI-70 - Removed Occupation
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 2023 - 12-01
-- Description: DWUI-94 - updated incomesource to multiselect
-- =============================================
-- Author: Vinnie Pisaniello
-- Alter date: 2023 - 12-01
-- Description: DWUI-84 - MilitaryStatus
-- =============================================
*/

/* Alter View dbo.Contact_SRCVW */
CREATE OR ALTER VIEW [dbo].[vw_DW_SFDC_Contact] AS 
SELECT  
    XREF.SFID					                   AS [Id] -- Salesforce ID 
,   E.EntityId                                     AS [Data_Warehouse_ID__c]  -- Source Warehouse_id 

,   'HHD'+CAST(E.HouseholdId AS VARCHAR)           AS [Source_AccountId]  -- Source ID for look up to Account

,   E.LastName                                     AS [LastName] --  nvarchar(80)
,   LEFT(E.FirstName, 40)                          AS [FirstName] --  nvarchar(40)
,   E.NamePrefix                                   AS [Salutation] --  nvarchar(40)
,   LEFT(E.MiddleName, 40)                         AS [MiddleName] --  nvarchar(40)
,   E.NameSuffix                                   AS [Suffix] --  nvarchar(40)
,   concat(A.AddressLine1, CHAR(13)+CHAR(10)+NULLIF(A.AddressLine2,''), CHAR(13)+CHAR(10)+NULLIF(A.AddressLine3,''))  AS [OtherStreet] --  ntext(8)
,   A.City                                         AS [OtherCity] --  nvarchar(40)
,   rSP.StateProvinceName                          AS [OtherState] --  nvarchar(80)
,   rcty.CountyName								   AS [County__C] --nvarchar(100)
,   A.PostalCode                                   AS [OtherPostalCode] --  nvarchar(20)
,   rC.CountryName                                 AS [OtherCountry] --  nvarchar(80)
,   A.Latitude                                     AS [OtherLatitude] --  float
,   A.Longitude                                    AS [OtherLongitude] --  float
,   pMobile.PhoneNumber                            AS [MobilePhone] --  nvarchar(40)
,   pHome.PhoneNumber                              AS [HomePhone] --  nvarchar(40)
,   E.JobTitle                                     AS [Title] --  nvarchar(128)
,   rRS.ReferralSourceDesc                         AS [LeadSource] --  nvarchar(40)
,   E.Birthdate                                    AS [Birthdate] --  date
,   CASE 
    WHEN E.CreatedDate<E.UpdatedDate THEN E.CreatedDate 
	ELSE E.UpdatedDate 
	END  AS [CreatedDate] --  datetime
,	(SELECT Max(v) 
		FROM (VALUES ( E.UpdatedDate), (EA.UpdatedDate), (a.UpdatedDate), (CVN.LastModifiedDate)
		, (MSC.LastModifiedDate), (CVS.LastModifiedDate), (pHome.LastModifiedDate), (pMobile.LastModifiedDate)
		, (pWork.LastModifiedDate), (ePrimary.UpdatedDate), (eSecondary.UpdatedDate) ) AS value(v))  AS [LastModifiedDate] --  datetime
--,   eSecondary.EmailAddress+'.full'						 AS [npe01__AlternateEmail__c] --  nvarchar(80)
--,   ePrimary.EmailAddress+'.full'						AS [npe01__HomeEmail__c] --  nvarchar(80)
,CASE WHEN SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-QA' then eSecondary.EmailAddress+'.full'
	  WHEN SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-qa%' then eSecondary.EmailAddress+'.full'
	  WHEN SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-PR' then eSecondary.EmailAddress 
	  WHEN SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-prod%' then eSecondary.EmailAddress end as [npe01__AlternateEmail__c]
,CASE WHEN SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-QA' then ePrimary.EmailAddress+'.full'
      WHEN SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-qa%' then ePrimary.EmailAddress+'.full'
	  WHEN SUBSTRING(@@SERVERNAME,1,7) = 'NMSS-PR' then ePrimary.EmailAddress 
	  WHEN SUBSTRING(@@SERVERNAME,1,15) like 'nmss-sql-prod%' then ePrimary.EmailAddress end as [npe01__HomeEmail__c]
,   pPreferred.PreferredType                       AS [npe01__PreferredPhone__c] --  nvarchar(255)
,   CASE 
	WHEN ePrimary.EmailAddress IS NOT NULL THEN 'Primary' 
	ELSE NULL 
	END  AS [npe01__Preferred_Email__c] --  nvarchar(255)
,   rAT.AddressTypeName                            AS [npe01__Primary_Address_Type__c] --  nvarchar(255)
,   pWork.PhoneNumber                              AS [npe01__WorkPhone__c] --  nvarchar(40)
,   CVN.VolunteerNotes                             AS [GW_Volunteers__Volunteer_Notes__c] --  ntext(8)
,   CVS.VolunteerSkills                            AS [GW_Volunteers__Volunteer_Skills__c] --  ntext(8)
,   CASE WHEN E.VolunteerFlag=1 THEN 'Active' ELSE NULL END  AS [GW_Volunteers__Volunteer_Status__c] --  nvarchar(255)
,   rG.GenderName                                  AS [Gender__c] --  nvarchar(255)
,   ISNULL(E.DeceasedFlag,0)                       AS [npsp__Deceased__c] --  bit
,   C_local.ChapterName                            AS [Market__c] --  nvarchar(255)
,   ISNULL(E.AnonymousFlag,0)                                AS [Anonymous__c] --  bit
,   E.ActiveFlag                                   AS [Active__c] --  bit
,   MSC.MSConnections                              AS [Connection_to_MS__c] --  ntext(8)
,   E.DeceasedDate                                 AS [Deceased_Date__c] --  date
,   E.DiagnosisDate                                AS [Diagnosis_Date__c] --  date
,   E.EmployerName                                 AS [Employer_Name__c] --  nvarchar(255)
,   rET.EmployerTypeDesc                           AS [Employer_Type__c] --  nvarchar(255)
,   rES.EmploymentStatusDesc                       AS [Employment_Status__c] --  nvarchar(255)
,   cre.EthnicityName                              AS [Ethnicity__c] --  nvarchar(255)
,   rLS.LivingSituationName                        AS [Living_Situation__c] --  nvarchar(255)
,   E.MaidenName                                   AS [Maiden_Name__c] --  nvarchar(50)
,   rMS.MaritalStatusName                          AS [Marital_Status__c] --  nvarchar(255)
,   E.NumberOfPeopleSupportedByIncome              AS [Number_of_People_Supported_by_Income__c] --  float
--,   rO.OccupationName                              AS [Occupation__c] --  nvarchar(255)
,   E.PreferredName                                AS [Preferred_Name__c] --  nvarchar(50)
,   rCT_prim.CoverageTypeName                      AS [Primary_Health_Coverage_Type__c] --  nvarchar(255)
--,   rHC_prim.HealthCoverageDesc                    AS [Primary_Health_Coverage__c] --  nvarchar(255)
,   chc.HealthCoverage							   AS [Primary_Health_Coverage__c] --  nvarchar(255)
,   rIS.IncomeSourceName                           AS [Primary_Income_Source__c] --  nvarchar(255)
,   rL_prim.LanguageName                           AS [Primary_Language__c] --  nvarchar(255)
,   rL_sec.LanguageName                            AS [Secondary_Language__c] --  nvarchar(255)
--,   E.RetiredFlag                                  AS [Retired_Flag__c] --  bit
--,   rCT_sec.CoverageTypeName                       AS [Secondary_Health_Coverage_Type__c] --  nvarchar(255)
--,   rHC_sec.HealthCoverageDesc                     AS [Secondary_Health_Coverage__c] --  nvarchar(255)
,   E.ServiceProviderFlag                          AS [Service_Provider_Flag__c] --  bit
--,   E.VeteranFlag                                  AS [Veteran_Flag__c] --  bit
,   ISNULL(E.ChildFlag,0)                          AS [Child_Flag__c] --  bit
,   C_dm.ChapterName                               AS [Direct_Mail_Market__c] --  nvarchar(255)
,   E.AcquisitionDate                              AS [Acquisition_Date__c] --  date
,   XE.XrefEntityKey                               AS [Luminate_ID__c] --  nvarchar(120)
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
,	CASE WHEN  ISNULL(ePrimary.EmailDeliveryStatusCode,'G') = 'G' then 0 
	     WHEN  ePrimary.EmailDeliveryStatusCode in ('U', 'N') then 1 else null end AS Bad_Email_Primary__c
,	CASE WHEN  ISNULL(eSecondary.EmailDeliveryStatusCode,'G') = 'G' then 0 
	     WHEN  eSecondary.EmailDeliveryStatusCode in ('U', 'N') then 1 else null end AS Bad_Email_Secondary__c
,	CASE WHEN A.StandardizedFlag is null THEN 0 ELSE A.StandardizedFlag END		AS [StandardizedFlag__c]
,	CASE WHEN A.DoNotStandardizeFlag is null THEN 0 ELSE A.DoNotStandardizeFlag END		AS [DoNotStandardizeFlag__c]
, mil.MilitaryStatusDesc as Military_Status__c
FROM [CFG_NMSS_QA].dbo.tbl_Qualified_Entity AS qe with (nolock) -- used for NMSS Navigator Individuals
INNER JOIN [TommiQA1].[dbo].apfx_Entity AS E with (nolock)
	ON E.EntityId = qe.EntityId
LEFT JOIN [TommiQA1].[dbo].apfx_EntityAddress AS EA with (nolock)
	ON EA.EntityId = E.EntityId AND EA.ActiveFlag = 1 AND EA.PrimaryFlag = 1
LEFT JOIN [TommiQA1].[dbo].apfx_Address AS A with (nolock)
	ON A.AddressId = EA.AddressId
LEFT JOIN [TommiQA1].[dbo].apfx_refStateProvince AS rSP with (nolock)
	ON rSP.StateProvinceId = A.StateProvinceId AND rSP.CountryId = A.CountryId
LEFT JOIN [TommiQA1].[dbo].apfx_refCountry AS rC with (nolock)
	ON rC.CountryId = A.CountryId
LEFT JOIN [TommiQA1].[dbo].[apfx_refCounty] rcty with (nolock)
	ON rcty.CountyId = a.CountyId
LEFT JOIN [TommiQA1].[dbo].apfx_refReferralSource AS rRS with (nolock)
	ON rRS.ReferralSourceId = E.ReferralSourceId
-- [SFIntegration] Helper views:
LEFT JOIN [SFIntegration].[dbo].vw_TRAC_apfx_ConstituentVolunteerNote_ByConstituent AS CVN with (nolock)
	ON CVN.ConstituentId = E.EntityId
LEFT JOIN [SFIntegration].[dbo].vw_TRAC_apfx_ConstituentMSConnection_ByConstituent AS MSC with (nolock)
	ON MSC.ConstituentId = E.EntityId
LEFT JOIN [SFIntegration].[dbo].vw_TRAC_apfx_ConstituentVolunteerSkill_ByConstituent AS CVS with (nolock)
	ON CVS.ConstituentId = E.EntityId
LEFT JOIN [TommiQA1].[dbo].apfx_Chapter AS C_local with (nolock)
	ON C_local.ChapterCode = E.LocalChapterCode
LEFT JOIN [TommiQA1].[dbo]. apfx_Chapter AS C_dm with (nolock)
	ON C_dm.ChapterCode = E.DirectMailChapterCode
LEFT JOIN [TommiQA1].[dbo].apfx_refAddressType AS rAT with (nolock)
	ON rAT.AddressTypeCode = EA.AddressTypeCode
LEFT JOIN [TommiQA1].[dbo].apfx_refGender AS rG with (nolock)
	ON rG.GenderCode = E.GenderCode
LEFT JOIN [TommiQA1].[dbo].apfx_refEmployerType AS rET with (nolock)
	ON rET.EmployerTypeId = E.EmployerTypeId
LEFT JOIN [TommiQA1].[dbo].apfx_refEmploymentStatus AS rES with (nolock)
	ON rES.EmploymentStatusId = E.EmploymentStatusId
--LEFT JOIN [TommiQA1].[dbo].apfx_refEthnicity AS rE with (nolock)
--	ON rE.EthnicityCode = E.EthnicityCode
LEFT JOIN [SFIntegration].dbo.vw_NMSS_help_ConstituentRaceEthnicity cre with (nolock)
	ON cre.Constituentid = e.EntityId
LEFT JOIN [TommiQA1].[dbo].apfx_refLivingSituation AS rLS with (nolock)
	ON rLS.LivingSituationId = E.LivingSituationId
LEFT JOIN [TommiQA1].[dbo].apfx_refMaritalStatus AS rMS with (nolock)
	ON rMS.MaritalStatusCode = E.MaritalStatusCode
--LEFT JOIN [TommiQA1].[dbo].apfx_refOccupation AS rO with (nolock)
--	ON rO.OccupationId = E.OccupationId
LEFT JOIN [SFIntegration].dbo.vw_NMSS_help_ConstituentHealthCoverage as chc with (nolock)
	ON chc.ConstituentId = e.EntityId
--LEFT JOIN [TommiQA1].[dbo].apfx_refHealthCoverage AS rHC_prim with (nolock)----
--	ON rHC_prim.HealthCoverageId = E.PrimaryHealthCoverageId------
LEFT JOIN [TommiQA1].[dbo].apfx_refCoverageType AS rCT_prim with (nolock)
	ON rCT_prim.CoverageTypeId = chc.CoverageType
--LEFT JOIN [TommiQA1].[dbo].apfx_refHealthCoverage AS rHC_sec with (nolock)
--	ON rHC_sec.HealthCoverageId = E.SecondaryHealthCoverageId
--LEFT JOIN [TommiQA1].[dbo].apfx_refCoverageType AS rCT_sec with (nolock)
--	ON rCT_sec.CoverageTypeId = rHC_sec.CoverageType
--LEFT JOIN [TommiQA1].[dbo].apfx_refIncomeSource AS rIS with (nolock)
--	ON rIS.IncomeSourceId = E.PrimaryIncomeSourceId
LEFT JOIN [TommiQA1].[dbo].[vw_NMSS_help_ConstituentIncomeSources] as rIS with (nolock)
	ON rIS.ConstituentId = E.EntityId
LEFT JOIN [TommiQA1].[dbo].apfx_refLanguage AS rL_prim with (nolock)
	ON rL_prim.LanguageId = E.PrimaryLanguageId
LEFT JOIN [TommiQA1].[dbo].apfx_refLanguage AS rL_sec with (nolock)
	ON rL_sec.LanguageId = E.SecondaryLanguageId
LEFT JOIN [TommiQA1].[dbo].apfx_XrefEntity AS XE with (nolock)
	ON XE.EntityId = E.EntityId AND XE.XrefSystemCode = 'L' AND XE.ActiveFlag = 1
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_MobilePhone AS pMobile with (nolock)
	ON pMobile.EntityId = E.EntityId
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_WorkPhone AS pWork with (nolock)
	ON pWork.EntityId = E.EntityId
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_HomePhone AS pHome with (nolock)
	ON pHome.EntityId = E.EntityId
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_PrimaryEmail AS ePrimary with (nolock)
	ON ePrimary.EntityId = E.EntityId
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_SecondaryEmail AS eSecondary with (nolock)
	ON eSecondary.EntityId = E.EntityId
LEFT JOIN [SFIntegration].dbo.vw_TRAC_help_PreferredPhoneType AS pPreferred with (nolock)
	ON pPreferred.EntityId = E.EntityId

/** Change CFG_NMSS_QA to SFIntegration for Pre-Prod migration **/
LEFT JOIN [SFIntegration].dbo.XREF_Contact as xref with (nolock)
	ON XREF.DWID = CONVERT(varchar,E.EntityId)

/** CFG : Uncomment for Pre-Prod migration **/
LEFT JOIN [TommiQA1].[dbo].apfx_Entity_MergeHistory as m with (nolock) -- Left join for #940
	ON CONVERT(varchar,m.Original_EntityId) = XREF.DWID -- Loser exists in SF

LEFT JOIN [SFIntegration].dbo.vw_NMSS_Help_Contact_Global_Preferences AS prefs with (nolock) --DREF-9
	ON prefs.Data_Warehouse_ID__c = e.EntityId
LEFT JOIN [TommiQA1].[dbo].[apfx_refMilitaryStatus] mil on mil.MilitaryStatusId = e.MilitaryStatusId



WHERE 
XREF.DWID is not null -- Regular Update OR Winner of MDM Merge
	OR 
	XREF.DWID is null
	AND 
	E.EntityCategoryCode = 'I'
	AND ISNULL(E.LastName, '')<>''
	AND E.ActiveFlag = 1

/** CFG : Uncomment for Pre-Prod migration **/
	-----REQ #940 Addition-----------
	OR (XREF.DWID is null -- Winner doesn't exist in SF
	AND m.Original_EntityId is not null -- Loser does exist in SF
	--AND E.updatedUserId = 6107 -- The most recent updated user on the loser is the MDM process 
	AND E.EntityCategoryCode = 'I'
	AND ISNULL(E.LastName, '')<>'' 
	AND E.ActiveFlag = 1)
	

GO


