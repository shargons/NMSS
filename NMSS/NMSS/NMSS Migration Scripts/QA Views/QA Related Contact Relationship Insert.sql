SELECT DISTINCT
      [Source_npe4__RelatedContact__c]
INTO QA_Relationship_RelContacts
  FROM [CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Relationship] 


SELECT DISTINCT C.*
into Contact_RelatedRelationship_Insert
FROM [CFG_NMSS_QA].dbo.[QA_Relationship_RelContacts] A 
INNER JOIN
[CFG_NMSS_QA].[dbo].[vw_DW_SFDC_Contact] C
ON C.[Data_Warehouse_ID__c] = A.[Source_npe4__RelatedContact__c]

