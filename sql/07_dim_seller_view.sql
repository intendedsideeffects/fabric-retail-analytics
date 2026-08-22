-- ============================================================
-- 07 SELLER DIMENSION VIEW
-- Olist Retail Analysis
-- Grain: one row per seller
-- Contains seller identifiers and geographic attributes
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_dim_seller AS

SELECT
    -- Key
    seller_id,

    -- Geographic attributes
    seller_zip_code_prefix,
    seller_city,
    seller_state

FROM dbo.olist_sellers_dataset;
