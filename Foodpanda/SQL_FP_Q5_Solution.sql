/*
Q5. What’s the overall conversion rate for transactions by Device Category and OS?
-- conversions refers to sessions that has eventAction, 'transaction'
*/

-- all sessions by device and operating system
WITH all_session AS (
  SELECT
    deviceCategory,
    operatingSystem,
    COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) AS total_sessions
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`
  GROUP BY 1, 2
),

-- all sessions with eventAction 'transaction'
transaction_session AS (
  SELECT
    deviceCategory,
    operatingSystem,
    COUNT(DISTINCT CONCAT(fullvisitorid, visitId)) AS sessions_with_transaction
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  WHERE
    hit.eventAction = 'transaction'
  GROUP BY 1, 2
)

-- output
SELECT
  s.deviceCategory,
  s.operatingSystem,
  s.total_sessions,
  st.sessions_with_transaction,
  ROUND(st.sessions_with_transaction / s.total_sessions, 4) AS conversion_rate
FROM
  all_session s
  LEFT JOIN transaction_session st ON (s.deviceCategory, s.operatingSystem) = (st.deviceCategory, st.operatingSystem)
ORDER BY 1, 2
