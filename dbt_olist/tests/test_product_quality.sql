-- Teste para validar a qualidade dos dados de produtos
-- Verifica se os produtos têm informações mínimas necessárias

-- Produtos com nome muito curto (menos de 3 caracteres)
SELECT 
    'product_name_too_short' as issue_type,
    product_id,
    product_name_length,
    'product_name_length' as field_name
FROM {{ ref('silver_products') }}
WHERE product_name_length < 3

UNION ALL

-- Produtos com descrição muito curta (menos de 5 caracteres)
SELECT 
    'product_description_too_short' as issue_type,
    product_id,
    product_description_length,
    'product_description_length' as field_name
FROM {{ ref('silver_products') }}
WHERE product_description_length < 5

UNION ALL

-- Produtos com dimensões zero (impossível)
SELECT 
    'product_zero_dimensions' as issue_type,
    product_id,
    product_length_cm,
    'dimensions' as field_name
FROM {{ ref('silver_products') }}
WHERE product_length_cm = 0 OR product_height_cm = 0 OR product_width_cm = 0
