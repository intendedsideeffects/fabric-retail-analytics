-- ============================================================
-- 01 DATA EXPLORATION
-- Olist Retail Analysis
-- Initial exploration of orders, sales and product categories
-- ============================================================


-- ------------------------------------------------------------
-- 1. Preview order data
-- ------------------------------------------------------------

SELECT TOP 100
    *
FROM dbo.olist_orders_dataset;


-- ------------------------------------------------------------
-- 2. Explore order status distribution
-- ------------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS order_count
FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;


-- ------------------------------------------------------------
-- 3. Preview sales enriched with product categories
-- ------------------------------------------------------------

SELECT TOP 100
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    i.price,
    i.freight_value,
    p.product_category_name,
    t.product_category_name_english
FROM dbo.olist_orders_dataset AS o
INNER JOIN dbo.olist_order_items_dataset AS i
    ON o.order_id = i.order_id
LEFT JOIN dbo.olist_products_dataset AS p
    ON i.product_id = p.product_id
LEFT JOIN dbo.product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name;


-- ------------------------------------------------------------
-- 4. Explore sales performance by product category
-- ------------------------------------------------------------

SELECT
    t.product_category_name_english AS product_category,
    COUNT(DISTINCT i.order_id) AS total_orders,
    SUM(i.price) AS total_revenue,
    AVG(i.price) AS avg_item_price
FROM dbo.olist_order_items_dataset AS i
LEFT JOIN dbo.olist_products_dataset AS p
    ON i.product_id = p.product_id
LEFT JOIN dbo.product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
GROUP BY
    t.product_category_name_english
ORDER BY
    total_revenue DESC;
