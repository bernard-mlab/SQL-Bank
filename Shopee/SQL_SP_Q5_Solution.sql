WITH 
------------------------------------------------- rank orders by users
ranked_orders AS (
  SELECT
    userid
    ,orderid
    ,order_time
    ,gmv
    ,RANK() OVER(
      PARTITION BY userid
      ORDER BY order_time, orderid) AS ordersRank
  FROM order   
)

------------------------------------------------- find the first order GMV of each user
SELECT
  userid
  ,gmv
FROM ranked_orders
WHERE 1=1
  AND ordersRank = 1