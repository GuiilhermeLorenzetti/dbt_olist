-- Teste para identificar registros órfãos
-- Verifica se existem referências para registros que não existem nas tabelas pai

-- Orphaned order_items (sem order correspondente)
SELECT 
    'order_items_without_order' as issue_type,
    oi.order_id,
    'order_id' as field_name
FROM {{ ref('silver_order_items') }} oi
LEFT JOIN {{ ref('silver_orders') }} o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- Orphaned order_items (sem product correspondente)
SELECT 
    'order_items_without_product' as issue_type,
    oi.product_id,
    'product_id' as field_name
FROM {{ ref('silver_order_items') }} oi
LEFT JOIN {{ ref('silver_products') }} p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

-- Orphaned order_items (sem seller correspondente)
SELECT 
    'order_items_without_seller' as issue_type,
    oi.seller_id,
    'seller_id' as field_name
FROM {{ ref('silver_order_items') }} oi
LEFT JOIN {{ ref('silver_sellers') }} s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL

UNION ALL

-- Orphaned order_payments (sem order correspondente)
SELECT 
    'order_payments_without_order' as issue_type,
    op.order_id,
    'order_id' as field_name
FROM {{ ref('silver_order_payments') }} op
LEFT JOIN {{ ref('silver_orders') }} o ON op.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- Orphaned order_reviews (sem order correspondente)
SELECT 
    'order_reviews_without_order' as issue_type,
    ore.order_id,
    'order_id' as field_name
FROM {{ ref('silver_order_reviews') }} ore
LEFT JOIN {{ ref('silver_orders') }} o ON ore.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

-- Orphaned orders (sem customer correspondente)
SELECT 
    'orders_without_customer' as issue_type,
    o.customer_id,
    'customer_id' as field_name
FROM {{ ref('silver_orders') }} o
LEFT JOIN {{ ref('silver_customers') }} c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
