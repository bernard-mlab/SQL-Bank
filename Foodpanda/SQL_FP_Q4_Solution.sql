/*
Q4. How many sessions change their order payment method?
*/

-- A1. get all event hits that has 'order_payment_method.chosen'
WITH payment_hit AS (
  SELECT
    fullvisitorid,
    visitid,
    visitStartTime,
    hit.hitNumber,
    hit.eventAction
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  WHERE
    hit.eventAction = 'order_payment_method.chosen'
),

-- A2. extract payment methods from custom dimensions & clean invalid values
payment_method AS (
  SELECT
    fullvisitorid,
    visitid,
    visitStartTime,
    hit.hitNumber,
    CASE
      WHEN TRIM(cd.value) = '' THEN 'NA'
      WHEN TRIM(cd.value) = 'null' THEN 'NA'
      ELSE TRIM(cd.value)
    END AS payment_method_cleaned
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit, UNNEST(hit.customDimensions) AS cd
  WHERE
    cd.index = 25
),

-- A3. consolidate hits relating to payment
payment_info AS (
  SELECT
    ph.fullvisitorid,
    ph.visitid,
    COUNT(DISTINCT pm.payment_method_cleaned) AS payment_method_used
  FROM
    payment_hit ph
    LEFT JOIN payment_method pm ON (ph.fullvisitorid, ph.visitid, ph.hitNumber) = (pm.fullvisitorid, pm.visitid, pm.hitNumber)
  GROUP BY 1, 2
)

-- output
SELECT
  COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) AS sessions_with_payment_method_change
FROM
  payment_info
WHERE
  payment_method_used > 1
