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
  p.name

FROM allCalls c
LEFT JOIN phones p 
  ON c.phoneNo = p.phone_number

GROUP BY 1
HAVING callDuration >= 10
ORDER BY 1

