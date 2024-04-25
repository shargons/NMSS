-- Form Complete Date Change API name and label 
--Documentation of Diagnosed Date 
select * from apfx_refClassification
WHERE ClassificationName = 'CONFDISC'

select * from apfx_refClassificationValue
Where ClassificationId = 923

--Related Condition 
select * from apfx_refClassification
WHERE ClassificationName = 'DEMYELINATNG'

select * from apfx_refClassificationValue
Where ClassificationId = 924
and ActiveFlag = 1


