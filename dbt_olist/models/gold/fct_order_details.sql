-- models/gold/fct_order_details.sql

-- 1. Pré-agregação de pagamentos para evitar duplicação de valores
WITH order_payments AS (
    SELECT
        order_id
        , SUM(CASE WHEN payment_type = 'credit_card' THEN payment_value ELSE 0 END) AS credit_card_payment_value
        , SUM(CASE WHEN payment_type = 'boleto' THEN payment_value ELSE 0 END) AS boleto_payment_value
        , SUM(CASE WHEN payment_type = 'voucher' THEN payment_value ELSE 0 END) AS voucher_payment_value
        , SUM(payment_value) AS total_payment_value
    FROM {{ ref('silver_order_payments') }}
    GROUP BY 1
),

-- 2. Junção principal
final AS (
    SELECT
        -- Chaves
        oi.order_id
        , oi.order_item_id
        , o.customer_id
        , c.customer_unique_id
        , oi.product_id
        , oi.seller_id

        -- Timestamps
        , o.purchase_timestamp
        , o.approved_at
        , o.delivered_to_customer_at
        , o.estimated_delivery_at

        -- Métricas de Negócio
        , oi.price
        , oi.freight_value
        , pmt.total_payment_value
        , r.review_score

        -- Lógica de Tempo
        , EXTRACT(DAY FROM (o.delivered_to_customer_at - o.purchase_timestamp)) AS delivery_time_in_days

        -- Dimensões
        , o.order_status
        , pt.product_category_name_english AS product_category
        , c.customer_city
        , c.customer_state
        , s.seller_city
        , s.seller_state

    FROM {{ ref('silver_order_items') }} AS oi
    LEFT JOIN {{ ref('silver_orders') }} AS o ON oi.order_id = o.order_id
    LEFT JOIN order_payments AS pmt ON oi.order_id = pmt.order_id
    LEFT JOIN {{ ref('silver_customers') }} AS c ON o.customer_id = c.customer_id
    LEFT JOIN {{ ref('silver_products') }} AS p ON oi.product_id = p.product_id
    LEFT JOIN {{ ref('silver_sellers') }} AS s ON oi.seller_id = s.seller_id
    LEFT JOIN {{ ref('silver_product_category_translation') }} AS pt ON p.product_category_name = pt.product_category_name
    LEFT JOIN {{ ref('silver_order_reviews') }} AS r ON o.order_id = r.order_id
)

SELECT * FROM final