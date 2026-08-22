-- ============================================================
-- 08 ORDER PRODUCT REVIEWS VIEW
-- Olist Retail Analysis
-- Grain: one row per order and product
-- Links order-level review scores to products while avoiding
-- duplicate weighting from multiple items of the same product
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_order_product_reviews AS

SELECT DISTINCT
    f.order_id,
    f.product_id,
    f.order_date,
    f.avg_review_score

FROM dbo.vw_fact_sales AS f

WHERE f.avg_review_score IS NOT NULL;
