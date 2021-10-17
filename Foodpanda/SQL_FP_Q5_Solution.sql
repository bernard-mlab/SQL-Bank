/*
Q5. What’s the overall conversion rate for transactions by Device Category and OS?
-- conversions refers to sessions that has eventAction, 'transaction'
*/

-- all sessions and trnansaction info by device and operating system
WITH sessions_txn AS (
  SELECT
    fullvisitorid,
    visitid,
    deviceCategory,
    operatingSystem,
    MAX(IF(hit.eventAction = 'transaction', 1, 0)) AS session_with_transaction
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  GROUP BY 1, 2, 3, 4
)

-- output
SELECT
  deviceCategory,
  operatingSystem,
  COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) AS total_sessions,
  SUM(session_with_transaction) AS total_transactions,
  ROUND(SUM(session_with_transaction) / COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) * 100, 2) AS conversion_rate
FROM
  sessions_txn
GROUP BY 1, 2
ORDER BY 1, 2
