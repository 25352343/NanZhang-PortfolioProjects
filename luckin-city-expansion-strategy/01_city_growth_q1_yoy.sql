
/*
Business Question:
    Which cities showed the fastest GMV YoY growth
    in 22Q1 compared with 21Q1?

Business Value:
    - Remove seasonality impact (Q1 vs Q1)
    - Support city expansion prioritization

*/

WITH city_q1_gmv AS (
    SELECT
        CASE 
            WHEN year = 2022 AND month < 4 THEN '22Q1'
            WHEN year = 2021 AND month < 4 THEN '21Q1'
            ELSE 'other'
        END AS quarter,
        city,
        SUM(gmv) AS city_gmv,
        COUNT(DISTINCT mendianid) AS store_count
    FROM data1.xxdd_all_huizong_month_dws
    WHERE ds > 1
    GROUP BY
        CASE 
            WHEN year = 2022 AND month < 4 THEN '22Q1'
            WHEN year = 2021 AND month < 4 THEN '21Q1'
            ELSE 'other'
        END,
        city
),

gmv_22q1 AS (
    SELECT * FROM city_q1_gmv WHERE quarter = '22Q1'
),

gmv_21q1 AS (
    SELECT * FROM city_q1_gmv WHERE quarter = '21Q1'
)

SELECT
    a.city,
    a.city_gmv AS gmv_22q1,
    b.city_gmv AS gmv_21q1,
    CASE 
        WHEN b.city_gmv > 0 
        THEN a.city_gmv / b.city_gmv 
        ELSE 0 
    END AS yoy_growth_rate,
    a.store_count AS store_count_22q1
FROM gmv_22q1 a
LEFT JOIN gmv_21q1 b
    ON a.city = b.city
ORDER BY yoy_growth_rate DESC;
