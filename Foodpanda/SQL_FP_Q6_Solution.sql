/*
Q6. What’s the conversion rate from the shop list page to the shop details page?
Approach:
i)  get sessions with 'shop_list.loaded' hits is captured, and it's first hits
ii) identify sessions from where 'shop_details.loaded' is captured after 'shop_list.loaded'
    'shop_details.loaded' tag that are fired before 'shop_details.loaded' would not be counted
iii) get distinct visits to the shop details page and shop listing page within a session. (conversion rate)
*/

-- all sessions where  shop list tag is captured
WITH shop_list_sessions AS (
  SELECT
    fullvisitorid,
    visitid,
    MIN(hit.hitNumber) AS first_shop_list_hits
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  WHERE
    LOWER(hit.eventAction) = 'shop_list.loaded'
  GROUP BY 1, 2
),

-- all events where shop detail tag is captured
shop_details_sessions AS (
  SELECT
    fullvisitorid,
    visitid,
    hit.hitNumber AS shop_details_hits
  FROM
    `dhh-analytics-hiringspace.GoogleAnalyticsSample.ga_sessions_export`, UNNEST(hit) AS hit
  WHERE
    LOWER(hit.eventAction) = 'shop_details.loaded'
),

-- filter for events where shop detail tag is captured after 'shop_list.loaded'
shop_details_sessions_filtered AS (
  SELECT
    l.fullvisitorid,
    l.visitid,
    COUNT(DISTINCT d.shop_details_hits) AS total_shop_details_hits
  FROM
    shop_list_sessions l
    LEFT JOIN shop_details_sessions d
      ON l.fullvisitorid = d.fullvisitorid
      AND l.visitid = d.visitid
      AND l.first_shop_list_hits < d.shop_details_hits  --validation to remove shop_details_hits that are smaller than shop list hits
  GROUP BY 1, 2
)

-- output
SELECT
  COUNT(DISTINCT CONCAT(fullvisitorid, visitid)) AS sessions_with_shop_list,
  SUM(IF(total_shop_details_hits > 0, 1, 0)) AS sessions_with_shop_details,
  ROUND((SUM(IF(total_shop_details_hits > 0, 1, 0))) / (COUNT(DISTINCT CONCAT(fullvisitorid, visitid))) * 100, 2) AS shop_conversion_rate
FROM
  shop_details_sessions_filtered
