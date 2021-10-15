/*
Q1. How many sessions are there?
*/

-- number of sessions that exists in the sample dataset
SELECT
  COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) AS sessions
FROM
  `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`
