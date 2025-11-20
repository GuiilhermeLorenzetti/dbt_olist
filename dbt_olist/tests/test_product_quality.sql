-- Test to validate product data quality
-- Checks if products have minimum necessary information

-- Products with very short name (less than 3 characters)
SELECT 
    'product_name_too_short' as issue_type,
    product_id,
    product_name_length,
    'product_name_length' as field_name
FROM {{ ref('silver_products') }}
WHERE product_name_length < 3

UNION ALL

-- Products with very short description (less than 5 characters)
SELECT 
    'product_description_too_short' as issue_type,
    product_id,
    product_description_length,
    'product_description_length' as field_name
FROM {{ ref('silver_products') }}
WHERE product_description_length < 5

UNION ALL

-- Products with zero dimensions (impossible)
SELECT 
    'product_zero_dimensions' as issue_type,
    product_id,
    product_length_cm,
    'dimensions' as field_name
FROM {{ ref('silver_products') }}
WHERE product_length_cm = 0 OR product_height_cm = 0 OR product_width_cm = 0
