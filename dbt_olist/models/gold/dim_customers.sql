-- models/gold/dim_customers.sql

WITH order_payments_aggregated AS ( -- 1. CTE criada a partir da subquery
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM {{ ref('silver_order_payments') }}
    GROUP BY 1
),

customer_orders AS (
    SELECT
        c.customer_unique_id
        , c.customer_city
        , c.customer_state
        , o.order_id
        , o.purchase_timestamp
        , p.total_payment_value
    FROM {{ ref('silver_customers') }} AS c
    LEFT JOIN {{ ref('silver_orders') }} AS o ON c.customer_id = o.customer_id
    LEFT JOIN order_payments_aggregated AS p ON o.order_id = p.order_id -- 2. Join com a nova CTE
),

final AS (
    SELECT
        customer_unique_id
        , MIN(purchase_timestamp) AS first_order_timestamp
        , MAX(purchase_timestamp) AS last_order_timestamp
        , COUNT(DISTINCT order_id) AS number_of_orders
        , SUM(total_payment_value) AS lifetime_value
        , MAX(customer_city) AS last_city -- Pega a cidade da última compra
        , MAX(customer_state) AS last_state -- Pega o estado da última compra
    FROM customer_orders
    GROUP BY 1
)

SELECT * FROM final