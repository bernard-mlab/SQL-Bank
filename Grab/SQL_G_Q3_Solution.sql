WITH
------------------------------------------------- putting caller and callee call duration in a same column
allCalls AS (
  SELECT 
    caller AS phoneNo
    ,duration AS duration
  FROM calls

  UNION ALL

  SELECT
    callee AS phoneNo
    ,duration AS duration
  FROM calls
)

------------------------------------------------- get clients who talked for at least 10mins in total
SELECT  
  name
FROM (
  SELECT
    p.name
    ,SUM(c.duration) AS callDuration

  FROM allCalls c
  LEFT JOIN phones p 
    ON c.phoneNo = p.phone_number

  GROUP BY 1
)

WHERE callDuration >= 10
ORDER BY 1

