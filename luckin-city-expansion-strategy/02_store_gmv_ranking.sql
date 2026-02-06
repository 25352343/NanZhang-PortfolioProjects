
/*
 
Business Question:
    Within each city in 22Q1,
    which stores contributed the most GMV?

Analysis Goal:
    - Identify whether city growth is driven
      by a few flagship stores or multiple stores

  */

SELECT
    city,
    mendianid,
    SUM(gmv) AS store_q1_gmv,
    ROW_NUMBER() OVER (
        PARTITION BY city
        ORDER BY SUM(gmv) DESC
    ) AS store_rank
FROM data1.xxdd_all_huizong_month_dws
WHERE ds > 1
  AND year = 2022
  AND month < 4
GROUP BY city, mendianid
HAVING store_rank <= 3;
