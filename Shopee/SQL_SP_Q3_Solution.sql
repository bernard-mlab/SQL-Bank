------------------------------------------------- find the first order date of each user
SELECT
  userid
  ,order_time

FROM (
  SELECT
    userid
    ,orderid
    ,order_time
    ,RANK() OVER(
      PARTITION BY userid
      ORDER BY order_time) AS ordersRank
  FROM order 
)
WHERE 1=1
  AND ordersRank = 1

ORDER BY 1