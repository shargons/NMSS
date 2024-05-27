

/******* DBAmp Delete Script *********/
DROP TABLE Case_DELETE
DECLARE @_table_server	nvarchar(255)	=	DB_NAME()
EXECUTE sf_generate 'Delete',@_table_server, 'Case_DELETE'

INSERT INTO Case_DELETE(Id) SELECT Id FROM [Case] where Subject = 'Historical Files'

DECLARE @_table_server	nvarchar(255) = DB_NAME()
EXECUTE	SF_TableLoader
		@operation		=	'Delete'
,		@table_server	=	@_table_server
,		@table_name		=	'Case_DELETE'