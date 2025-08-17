-- models/gold/agg_seller_performance.sql

WITH seller_metrics AS (
    SELECT
        oi.seller_id
        , oi.order_id
        , oi.price
        , oi.freight_value
        , r.review_score
        , o.purchase_timestamp
    FROM {{ ref('silver_order_items') }} AS oi
    LEFT JOIN {{ ref('silver_orders') }} AS o ON oi.order_id = o.order_id
    LEFT JOIN {{ ref('silver_order_reviews') }} AS r ON oi.order_id = r.order_id
    WHERE o.order_status = 'delivered' -- Considera apenas pedidos entregues
),

final AS (
    SELECT
        s.seller_id
        , s.seller_city
        , s.seller_state
        , COUNT(DISTINCT sm.order_id) AS total_orders
        , SUM(sm.price) AS total_revenue
        , SUM(sm.freight_value) AS total_freight
        , AVG(sm.review_score) AS avg_review_score
        , MIN(sm.purchase_timestamp) AS first_sale_timestamp
        , MAX(sm.purchase_timestamp) AS last_sale_timestamp
    FROM {{ ref('silver_sellers') }} AS s
    LEFT JOIN seller_metrics AS sm ON s.seller_id = sm.seller_id
    GROUP BY 1, 2, 3
)

SELECT * FROM final