WITH
------------------------------------------------- create new col showing last day of month
transactionTbl AS (
  SELECT 
    *
    ,CASE 
      WHEN amount <= 0 THEN 'payment'
      ELSE 'incoming funds'
    END AS fund_flow
    ,LAST_DAY(date) AS last_day_of_month

  FROM transactions
),

------------------------------------------------- calculate if fee will be levy end of month
feeTbl AS (
  SELECT 
    txn.last_day_of_month AS date
    ,CASE 
      WHEN SUM(txn.amount) > -100 OR MAX(txn.rNum) < 3 THEN -5
      ELSE 0
    END AS amount
  FROM (
    SELECT 
      *
      ,ROW_NUMBER() OVER(
        PARTITION BY LAST_DAY(date)
        ORDER BY date) AS rNum
    FROM transactionTbl
    WHERE 1=1
      AND fund_flow = 'payment'
  ) txn
  
  GROUP BY 1  
),

------------------------------------------------- joining in missing months
fullFeeTbl AS (
  SELECT 
    me.date 
    ,IFNULL(amount, -5) AS amount
  FROM feeTbl f
  RIGHT JOIN (
    SELECT 
      LAST_DAY(date) AS date
    FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2020-12-31', INTERVAL 1 MONTH)) date
  ) me
    
    ON me.date = f.date
)

------------------------------------------------- aggregating all together
SELECT 
  -- SUM(amount) AS balance
  date
  ,amount
FROM (
  SELECT 
    date
    ,amount
  FROM transactions

  UNION ALL 

  SELECT 
    date
    ,amount 
  FROM fullFeeTbl
)
ORDER BY 1