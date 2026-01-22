-- Project: eBay Marketplace Analytics (ODPS/Hive-style SQL)
-- File: 04_pct_txn_from_good_sellers.sql
-- Task:
--   Calculate the percentage of transactions that came from sellers whose positive feedback ratio is >= 50%.
--
-- Definition:
--   seller_positive_ratio = positive_feedback_count / total_feedback_count
--   pct_transactions      = distinct_txns_from_good_sellers / distinct_txns_all_sellers
--
-- Note: CAST to DOUBLE to avoid integer division.

WITH good_sellers AS (
    SELECT
        seller_id,
        CAST(SUM(CASE WHEN feedback_score = 1 THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(1) AS seller_positive_ratio
    FROM data1.trans_fdback
    GROUP BY seller_id
    HAVING CAST(SUM(CASE WHEN feedback_score = 1 THEN 1 ELSE 0 END) AS DOUBLE) / COUNT(1) >= 0.5
)
SELECT
    CAST(COUNT(DISTINCT CASE WHEN gs.seller_id IS NOT NULL THEN f.trans_id END) AS DOUBLE)
    / COUNT(DISTINCT f.trans_id) AS pct_transactions_from_good_sellers
FROM data1.trans_fdback f
LEFT JOIN good_sellers gs
    ON f.seller_id = gs.seller_id
;
