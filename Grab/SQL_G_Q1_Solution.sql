WITH
------------------------------------------------- calculate host scores
host_scores AS (
  SELECT 
    host_team AS team_id
    ,CASE 
      WHEN host_goals > guest_goals THEN 3
      WHEN host_goals = guest_goals THEN 1
      WHEN host_goals < guest_goals THEN 0
    END AS scores

  FROM `bernard-mlab.sandbox.matches`
),

------------------------------------------------- calculate guest scores
guest_scores AS (
  SELECT 
    guest_team AS team_id
    ,CASE 
      WHEN guest_goals > host_goals THEN 3
      WHEN guest_goals = host_goals THEN 1
      WHEN guest_goals < host_goals THEN 0
    END AS scores

  FROM `bernard-mlab.sandbox.matches`
)

------------------------------------------------- aggregate & join to team name
SELECT 
  t.team_id
  ,t.team_name
  ,COALESCE(SUM(scores), 0) AS num_points
FROM (
  SELECT*
  FROM host_scores

  UNION ALL

  SELECT * 
  FROM guest_scores
) m

RIGHT JOIN `bernard-mlab.sandbox.teams` t
  ON m.team_id = t.team_id

GROUP BY 1,2
ORDER BY 3 DESC,1