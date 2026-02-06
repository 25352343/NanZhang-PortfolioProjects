
/*

Business Question:
    What is the monthly delivery GMV share
    for each store in 22Q1?

Business Value:
    - Evaluate delivery-driven growth potential
    - Support light-site, fast-expansion strategy
 
 */

WITH store_month_gmv AS (
    SELECT
        mendianid,
        city,
        month,
        SUM(gmv) AS total_month_gmv,
        SUM(
            CASE 
                WHEN fenlei = '外卖' THEN gmv 
                ELSE 0 
            END
        ) AS delivery_month_gmv
    FROM data1.xxdd_all_huizong_month_dws
    WHERE ds > 1
      AND year = 2022
      AND month < 4
    GROUP BY mendianid, city, month
)

SELECT
    mendianid,
    city,
    month,
    delivery_month_gmv,
    total_month_gmv,
    CASE
        WHEN total_month_gmv > 0
        THEN delivery_month_gmv / total_month_gmv
        ELSE 0
    END AS delivery_share
FROM store_month_gmv
ORDER BY city, mendianid, month;
