-- ============================================================
-- 04 FACT SALES VIEW
-- Olist Retail Analysis
-- Grain: one row per order item
-- Combines order-level and item-level sales data
-- Enriches each order item with the aggregated review score
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_fact_sales AS

SELECT
    -- Keys
    o.order_id,
    i.order_item_id,
    o.customer_id,
    i.product_id,
    i.seller_id,

    -- Order attributes
    o.order_purchase_timestamp,
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    o.order_status,

    -- Measures
    i.price,
    i.freight_value,

    -- Review enrichment
    r.avg_review_score

FROM dbo.olist_orders_dataset AS o

INNER JOIN dbo.olist_order_items_dataset AS i
    ON o.order_id = i.order_id

LEFT JOIN dbo.vw_order_reviews AS r
    ON o.order_id = r.order_id;
