-- models/marts/fct_orders.sql

-- 1. Agrega e pivota os dados de pagamento por pedido
WITH payments_pivoted AS (

    SELECT
        order_id,
        SUM(CASE WHEN payment_type = 'credit_card' THEN payment_value ELSE 0 END) AS credit_card_payment_value,
        SUM(CASE WHEN payment_type = 'boleto' THEN payment_value ELSE 0 END) AS boleto_payment_value,
        SUM(CASE WHEN payment_type = 'voucher' THEN payment_value ELSE 0 END) AS voucher_payment_value,
        SUM(CASE WHEN payment_type NOT IN ('credit_card', 'boleto', 'voucher') THEN payment_value ELSE 0 END) AS other_payment_value,
        SUM(payment_value) AS total_payment_value
    
    FROM {{ ref('silver_order_payments') }}
    GROUP BY 1

),

-- 2. Calcula a média de avaliação (review score) por pedido
order_reviews AS (

    SELECT
        order_id,
        AVG(review_score) AS average_review_score
    
    FROM {{ ref('silver_order_reviews') }}
    GROUP BY 1

),

-- 3. Junta os dados de pagamentos e avaliações aos pedidos
final AS (

    SELECT 
        -- Chaves e IDs
        ord.order_id,
        ord.customer_id,

        -- Timestamps e Datas
        ord.purchase_timestamp,
        ord.approved_at,
        ord.delivered_to_carrier_at,
        ord.delivered_to_customer_at,
        ord.estimated_delivery_at,

        -- Atributos do Pedido
        ord.order_status,
        rev.average_review_score,

        -- Métricas de Pagamento
        pay.total_payment_value,
        pay.credit_card_payment_value,
        pay.boleto_payment_value,
        pay.other_payment_value,
        pay.voucher_payment_value
    
    FROM {{ ref('silver_orders') }} AS ord
    
    LEFT JOIN payments_pivoted AS pay
        ON ord.order_id = pay.order_id

    LEFT JOIN order_reviews AS rev
        ON ord.order_id = rev.order_id
)

SELECT * FROM final