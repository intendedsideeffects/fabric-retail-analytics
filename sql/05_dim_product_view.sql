-- ============================================================
-- 05 PRODUCT DIMENSION VIEW
-- Olist Retail Analysis
-- Grain: one row per product
-- Enriches product attributes with English category names
-- Category labels are cleaned upstream in Dataflow Gen2
-- ============================================================

CREATE OR ALTER VIEW dbo.vw_dim_product AS

SELECT
    -- Key
    p.product_id,

    -- Product category
    p.product_category_name,
    t.product_category_name_english,

    -- Product attributes
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM dbo.olist_products_dataset AS p

LEFT JOIN dbo.product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name;
