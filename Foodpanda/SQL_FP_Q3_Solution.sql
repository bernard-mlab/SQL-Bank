/*
Q3. How much time does it take on average to reach a transaction?
*/

-- get time to order for every 'transaction' eventAction
WITH transaction_hit AS (
  SELECT
    fullvisitorid,
    visitid,
    visitStartTime,
    hit.time AS time_to_order,
    CAST(FORMAT_TIMESTAMP('%T', TIMESTAMP_MILLIS(hit.time)) AS TIME) AS hhmmss,
    ROW_NUMBER() OVER(
      PARTITION BY fullvisitorid, visitId
      ORDER BY hit.hitNumber ASC
      ) AS orders_seq,
    TIME(TIMESTAMP_MILLIS(CAST(AVG(hit.time) OVER() AS INT64))) AS avg_time_to_order_agg
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  WHERE
    hit.eventAction = 'transaction'
)

-- output, by orders sequence
SELECT
  orders_seq,
  avg_time_to_order_agg,
  TIME(TIMESTAMP_MILLIS(CAST(AVG(time_to_order) AS INT64))) AS avg_time_to_order
FROM
  transaction_hit
GROUP BY 1, 2
ORDER BY 1
