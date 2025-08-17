-- models/gold/dim_customers.sql

WITH order_payments_aggregated AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM {{ ref('silver_order_payments') }}
    GROUP BY 1
),

customer_orders AS (

    SELECT
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        o.order_id,
        o.purchase_timestamp,
        p.total_payment_value
    FROM {{ ref('silver_customers') }} AS c
    LEFT JOIN {{ ref('silver_orders') }} AS o ON c.customer_id = o.customer_id
    LEFT JOIN order_payments_aggregated AS p ON o.order_id = p.order_id
),

ranked_customer_orders AS (
    SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY purchase_timestamp DESC) as order_rank
    FROM customer_orders
),

final AS (

    SELECT
        -- Dados agregados do cliente
        co.customer_unique_id,
        MIN(co.purchase_timestamp) AS first_order_timestamp,
        MAX(co.purchase_timestamp) AS last_order_timestamp,
        COUNT(DISTINCT co.order_id) AS number_of_orders,
        SUM(co.total_payment_value) AS lifetime_value,
        
        -- Dados do último pedido (obtidos com o JOIN)
        rco.customer_city AS last_city,
        rco.customer_state AS last_state
        
    FROM customer_orders AS co
    LEFT JOIN ranked_customer_orders AS rco 
        ON co.customer_unique_id = rco.customer_unique_id
        AND rco.order_rank = 1 -- Filtra para trazer APENAS a linha do último pedido

    GROUP BY 
        co.customer_unique_id,
        rco.customer_city,
        rco.customer_state
)

SELECT * FROM final