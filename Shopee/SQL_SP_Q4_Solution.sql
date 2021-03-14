WITH 
------------------------------------------------- rank orders by users
ranked_orders AS (
  SELECT
    userid
    ,orderid
    ,order_time
    ,RANK() OVER(
      PARTITION BY userid
      ORDER BY order_time) AS ordersRank
  FROM order   
)

-------------------------------------------------  number of users who made their first order in each country, each day
SELECT
  u.country
  ,ro.order_time 
  ,COUNT(ro.userid) AS users

FROM ranked_orders ro
LEFT JOIN user u 
  ON ro.userid = u.userid
WHERE 1=1
  AND ordersRank = 1
GROUP BY 1,2
ORDER BY 1,2