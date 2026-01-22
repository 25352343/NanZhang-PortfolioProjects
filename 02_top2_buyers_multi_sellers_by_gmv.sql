-- Project: eBay Marketplace Analytics (ODPS/Hive-style SQL)
-- File: 02_top2_buyers_multi_sellers_by_gmv.sql
-- Task:
--   Find the top 2 buyers (ranked by GMV) among buyers who purchased from > 1 distinct seller.
--   GMV is computed as (as-of price at transaction time) * quantity.
--
-- Notes on "as-of price":
--   For each transaction, we match the most recent listing price whose listing_date is not after the transaction date.

WITH multi_seller_buyers AS (
    SELECT
        buyer_id,
        COUNT(DISTINCT seller_id) AS distinct_seller_cnt
    FROM data1.ebay_trans
    GROUP BY buyer_id
    HAVING COUNT(DISTINCT seller_id) > 1
),
trans_with_asof_price AS (
    SELECT
        t.trans_id,
        t.buyer_id,
        t.seller_id,
        t.item_id,
        t.quantity,
        l.price,
        ROW_NUMBER() OVER (
            PARTITION BY t.trans_id
            ORDER BY l.listing_date DESC
        ) AS rnk
    FROM data1.ebay_trans t
    LEFT JOIN data1.ebay_lstg l
        ON t.item_id = l.item_id
       AND TO_CHAR(t.trans_timestamp, 'yyyymmdd') >= TO_CHAR(l.listing_date, 'yyyymmdd')
),
trans_gmv AS (
    SELECT
        trans_id,
        buyer_id,
        seller_id,
        quantity * price AS gmv
    FROM trans_with_asof_price
    WHERE rnk = 1
),
buyer_gmv AS (
    SELECT
        b.buyer_id,
        b.distinct_seller_cnt,
        SUM(g.gmv) AS total_gmv
    FROM multi_seller_buyers b
    LEFT JOIN trans_gmv g
        ON b.buyer_id = g.buyer_id
    GROUP BY b.buyer_id, b.distinct_seller_cnt
),
ranked AS (
    SELECT
        buyer_id,
        distinct_seller_cnt,
        total_gmv,
        ROW_NUMBER() OVER (ORDER BY total_gmv DESC) AS gmv_rank
    FROM buyer_gmv
)
SELECT
    buyer_id,
    distinct_seller_cnt,
    total_gmv,
    gmv_rank
FROM ranked
WHERE gmv_rank <= 2
ORDER BY gmv_rank
;
