-- ============================================================
-- 02 DATA QUALITY CHECKS
-- Olist Retail Analysis
-- Validation of keys, relationships, missing values and grain
-- ============================================================


-- ------------------------------------------------------------
-- 1. Validate dimension key uniqueness
-- ------------------------------------------------------------

-- Product dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM dbo.olist_products_dataset;

-- Customer dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM dbo.olist_customers_dataset;

-- Seller dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM dbo.olist_sellers_dataset;


-- ------------------------------------------------------------
-- 2. Validate referential integrity
-- ------------------------------------------------------------

-- Order items without matching product
SELECT
    COUNT(*) AS missing_products
FROM dbo.olist_order_items_dataset AS i
LEFT JOIN dbo.olist_products_dataset AS p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Order items without matching seller
SELECT
    COUNT(*) AS missing_sellers
FROM dbo.olist_order_items_dataset AS i
LEFT JOIN dbo.olist_sellers_dataset AS s
    ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- Orders without matching customer
SELECT
    COUNT(*) AS missing_customers
FROM dbo.olist_orders_dataset AS o
LEFT JOIN dbo.olist_customers_dataset AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- ------------------------------------------------------------
-- 3. Validate fact table grain
-- ------------------------------------------------------------

-- Orders: expected grain = one row per order
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM dbo.olist_orders_dataset;

-- Order items: multiple items can belong to one order
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders
FROM dbo.olist_order_items_dataset;


-- ------------------------------------------------------------
-- 4. Check product data completeness
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_products,
    SUM(
        CASE
            WHEN product_category_name IS NULL
                 OR TRIM(product_category_name) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_category,
    SUM(
        CASE
            WHEN product_name_lenght IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_name_length,
    SUM(
        CASE
            WHEN product_description_lenght IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_description_length
FROM dbo.olist_products_dataset;


-- ------------------------------------------------------------
-- 5. Validate review data grain
-- ------------------------------------------------------------

-- Compare review rows with distinct reviewed orders
SELECT
    COUNT(*) AS total_reviews,
    COUNT(DISTINCT order_id) AS distinct_reviewed_orders
FROM dbo.olist_order_reviews_dataset;

-- Identify orders with multiple reviews
SELECT TOP 20
    order_id,
    COUNT(*) AS review_count
FROM dbo.olist_order_reviews_dataset
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_count DESC;


-- ------------------------------------------------------------
-- 6. Validate sales fact after review enrichment
-- ------------------------------------------------------------

-- Confirm row count and revenue after joining aggregated reviews
SELECT
    COUNT(*) AS row_count,
    SUM(price) AS total_revenue,
    AVG(avg_review_score) AS avg_review_score
FROM dbo.vw_fact_sales;
