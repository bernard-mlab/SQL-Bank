WITH 
------------------------------------------------- group Cust_ID & Content_ID
grouped_table AS (
	SELECT
		*
		,RANK() OVER(
			PARTITION BY Cust_ID
			ORDER BY Play_Duration_Grp ASC) AS durationRank
	
	FROM (
		SELECT
			Cust_ID
			,Content_ID
			,SUM(Play_duration) AS Play_Duration_Grp
		FROM tbl
		GROUP BY 1,2
	)
)

------------------------------------------------- find least watched content
SELECT 
	Cust_ID
	,Content_ID
	,Play_Duration_Grp AS Play_duration

FROM grouped_table
WHERE 1=1
	AND durationRank = 1
