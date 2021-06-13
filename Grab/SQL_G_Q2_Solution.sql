WITH
------------------------------------------------- putting start and end time in a same column
startEndTime AS (
  SELECT
    PARSE_TIME("%H:%M", start_time) AS timing
    ,1 AS increment                            -- +1 to room when meeting starts
  FROM meetings

  UNION ALL

  SELECT
    PARSE_TIME("%H:%M", end_time) AS timing
    ,-1 AS increment                           -- -1 to room when meeting ends
  FROM meetings
)

------------------------------------------------- calculate max number of rooms occupied
SELECT
  SUM(SUM(increment)) OVER (ORDER BY timing) AS rooms

FROM startEndTime
GROUP BY timing
ORDER BY rooms DESC
LIMIT 1
