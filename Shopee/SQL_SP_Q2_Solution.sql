------------------------------------------------- count the number of orders per country
SELECT
  u.country
  ,COUNT(o.orderid) as orders
  ,COUNT(DISTINCT o.orderid) AS uniqueOrders
FROM order o
LEFT JOIN user u
  ON o.userid = u.userid
GROUP BY 1
ORDER BY 2 DESC