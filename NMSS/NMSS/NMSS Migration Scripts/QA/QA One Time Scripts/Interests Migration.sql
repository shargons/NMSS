SELECT * FROM [TommiQA1].dbo.apfx_refResponseType
SELECT * FROM [TommiQA1].dbo.apfx_refLiteratureType
SELECT * FROM [TommiQA1].dbo.apfx_refTrackedTopic
SELECT * FROM [TommiQA1].dbo.apfx_refResourceType

SELECT DISTINCT R.ResponseCategoryId
FROM [TommiQA1].dbo.apfx_refResponseType R
INNER JOIN  [TommiQA1].dbo.apfx_InteractionDetailResponseType IR
ON IR.ResponseTypeId = R.ResponseTypeID
WHERE R.ActiveFlag= 1
ORDER BY ResponseCategoryId
-- 31

SELECT DISTINCT R.ResponseTypeId,R.ResponseCategoryId
FROM [TommiQA1].dbo.apfx_refResponseType R
INNER JOIN  [TommiQA1].dbo.apfx_InteractionDetailResponseType IR
ON IR.ResponseTypeId = R.ResponseTypeID
WHERE R.ActiveFlag= 1
ORDER BY ResponseCategoryId
-- 267

SELECT DISTINCT R.TrackedTopicId
FROM [TommiQA1].dbo.apfx_refTrackedTopic R
INNER JOIN  [TommiQA1].dbo.apfx_InteractionDetailTrackedTopic IR
ON IR.TrackedTopicId = R.TrackedTopicId
WHERE R.ActiveFlag= 1
-- 11

SELECT DISTINCT R.LiteratureCategoryId
FROM [TommiQA1].dbo.apfx_refLiteratureType R
INNER JOIN  [TommiQA1].dbo.apfx_InteractionDetailLiteratureType IR
ON IR.LiteratureTypeId = R.LiteratureTypeId
WHERE R.ActiveFlag= 1
-- 3

SELECT DISTINCT R.LiteratureTypeId
FROM [TommiQA1].dbo.apfx_refLiteratureType R
INNER JOIN  [TommiQA1].dbo.apfx_InteractionDetailLiteratureType IR
ON IR.LiteratureTypeId = R.LiteratureTypeId
WHERE R.ActiveFlag= 1
-- 106