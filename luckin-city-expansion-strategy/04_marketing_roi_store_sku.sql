
/*
 
Business Question:
    In Feb 2023, for stores with weekly marketing
    spend > 500, what are the Top 5 selling SKUs
    in the same week?

Analysis Goal:
    - Validate whether marketing spend drives
      real sales instead of exposure only
 
*/

WITH weekly_marketing_store AS (
    SELECT
        WEEKOFYEAR(TO_DATE(days)) AS week_no,
        mendianid,
        SUM(tuiguangmoney) AS weekly_marketing_spend
    FROM data1.xxdd_waimai_tuiguang_meituan_dws
    WHERE ds = MAX_PT('data1.xxdd_waimai_tuiguang_meituan_dws')
      AND days LIKE '2023-2%'
    GROUP BY WEEKOFYEAR(TO_DATE(days)), mendianid
    HAVING SUM(tuiguangmoney) > 500
),

store_id_mapping AS (
    SELECT
        pingtaiid,
        zhongtaiid
    FROM data1.xxdd_waimai_mendianid
    WHERE ds > 1
),

weekly_store_sales AS (
    SELECT
        WEEKOFYEAR(TO_DATE(REPLACE(days,'/','-'))) AS week_no,
        mendianid,
        shangpinname,
        SUM(sales) AS weekly_sales,
        ROW_NUMBER() OVER (
            PARTITION BY 
                WEEKOFYEAR(TO_DATE(REPLACE(days,'/','-'))),
                mendianid
            ORDER BY SUM(sales) DESC
        ) AS sales_rank
    FROM data1.xxdd_all_shangpin_sales_dws
    WHERE ds > 1
      AND days LIKE '2023/2%'
    GROUP BY
        WEEKOFYEAR(TO_DATE(REPLACE(days,'/','-'))),
        mendianid,
        shangpinname
)

SELECT
    a.week_no,
    a.zhongtaiid AS mendianid,
    b.shangpinname,
    b.weekly_sales,
    b.sales_rank
FROM (
    SELECT
        w.week_no,
        m.zhongtaiid
    FROM weekly_marketing_store w
    LEFT JOIN store_id_mapping m
        ON w.mendianid = m.pingtaiid
) a
LEFT JOIN weekly_store_sales b
    ON a.zhongtaiid = b.mendianid
   AND a.week_no = b.week_no
WHERE b.sales_rank <= 5;
