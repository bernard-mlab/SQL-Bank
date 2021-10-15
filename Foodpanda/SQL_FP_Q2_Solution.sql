/*
Q2. How many sessions does each user create?
*/

-- number of sessions made by each user within the sample dataset
SELECT
  fullvisitorid,
  COUNT(DISTINCT visitid) AS session_per_user
FROM
  `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`
GROUP BY 1
