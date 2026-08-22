-- ============================================================
-- 06 CUSTOMER DIMENSION VIEW
-- Olist Retail Analysis
-- Grain: one row per customer
-- Contains customer identifiers and geographic attributes
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_dim_customer AS

SELECT
    -- Keys
    customer_id,
    customer_unique_id,

    -- Geographic attributes
    customer_zip_code_prefix,
    customer_city,
    customer_state

FROM dbo.olist_customers_dataset;
