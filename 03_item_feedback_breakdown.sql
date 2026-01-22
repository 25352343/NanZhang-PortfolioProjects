-- Project: eBay Marketplace Analytics (ODPS/Hive-style SQL)
-- File: 03_item_feedback_breakdown.sql
-- Task:
--   Count positive, neutral, and negative feedback for each item.
--   feedback_score mapping: 1 = positive, 0 = neutral, -1 = negative.

SELECT
    item_id,
    SUM(CASE WHEN feedback_score =  1 THEN 1 ELSE 0 END) AS pos_cnt,
    SUM(CASE WHEN feedback_score =  0 THEN 1 ELSE 0 END) AS neu_cnt,
    SUM(CASE WHEN feedback_score = -1 THEN 1 ELSE 0 END) AS neg_cnt
FROM data1.trans_fdback
GROUP BY item_id
;
