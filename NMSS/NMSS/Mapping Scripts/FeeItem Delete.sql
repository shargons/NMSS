drop table FeedItem_Delete
SELECT iD 
INTO FeedItem_Delete
FROM FeedITem
WHERE CreatedById = '005f4000002IztQAAS'
AND tYPE = 'CreateRecordEvent'
AND pARENTID LIKE '500%'

EXEC SF_TableLoader 'hARDdELETE:BULKAPI','CFG_NMSS_PREPROD','FeedItem_Delete'