-- ============================================================
-- 03 ORDER REVIEWS VIEW
-- Olist Retail Analysis
-- Grain: one row per order
-- Aggregates multiple reviews before joining to sales
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_order_reviews AS

SELECT
    order_id,

    -- Average score if an order has multiple reviews
    AVG(CAST(review_score AS DECIMAL(4,2))) AS avg_review_score,

    -- Number of reviews associated with the order
    COUNT(*) AS review_count

FROM dbo.olist_order_reviews_dataset

GROUP BY
    order_id;
