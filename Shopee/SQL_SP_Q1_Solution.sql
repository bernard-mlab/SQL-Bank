------------------------------------------------- count the number of users per country
SELECT
  country
  ,COUNT(userid) as users
  ,COUNT(DISTINCT userid) AS uniqueUsers
FROM user
GROUP BY 1
ORDER BY 2 DESC
