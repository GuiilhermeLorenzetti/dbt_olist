-- models/marts/fct_orders.sql

-- 1. Aggregates and pivots payment data by order
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

-- 2. Calculates average review score by order
order_reviews AS (

    SELECT
        order_id,
        AVG(review_score) AS average_review_score
    
    FROM {{ ref('silver_order_reviews') }}
    GROUP BY 1

),

-- 3. Joins payment and review data to orders
final AS (

    SELECT 
        -- Keys and IDs
        ord.order_id,
        ord.customer_id,

        -- Timestamps and Dates
        ord.purchase_timestamp,
        ord.approved_at,
        ord.delivered_to_carrier_at,
        ord.delivered_to_customer_at,
        ord.estimated_delivery_at,

        -- Order Attributes
        ord.order_status,
        rev.average_review_score,

        -- Payment Metrics
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

SELECT 
    *,
    CURRENT_DATE as last_updated_at 
 FROM final