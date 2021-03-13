WITH 
------------------------------------------------- group Cust_ID & Content_ID
grouped_table AS (
  SELECT
    Cust_ID
    ,Content_ID
    ,SUM(Play_duration) AS Play_Duration_Grp
  FROM tbl1
  GROUP BY 1,2
),

------------------------------------------------- find acquisition channel time
SELECT
  t2.Acq_channel
  ,SUM(Play_Duration_Grp) AS Play_duration
FROM grouped_table gt1
INNER JOIN tbl2 t2
  ON gt1.Cust_ID = t2.Advertising_id OR gt1.Cust_ID = t2.IDFA OR gt1.Cust_ID = t2.IDFV
GROUP BY 1
ORDER BY 2 DESC
