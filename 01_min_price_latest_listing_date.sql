-- Project: eBay Marketplace Analytics (ODPS/Hive-style SQL)
-- File: 01_min_price_latest_listing_date.sql
-- Task: For each item, find the latest listing_date when the item was at its historical lowest price.

WITH min_price AS (
    SELECT
        item_id,
        MIN(price) AS min_price
    FROM data1.ebay_lstg
    GROUP BY item_id
),
latest_date_per_price AS (
    SELECT
        item_id,
        price,
        MAX(listing_date) AS latest_listing_date
    FROM data1.ebay_lstg
    GROUP BY item_id, price
)
SELECT
    a.item_id,
    a.min_price,
    b.latest_listing_date
FROM min_price a
LEFT JOIN latest_date_per_price b
    ON a.item_id = b.item_id
   AND a.min_price = b.price
;
