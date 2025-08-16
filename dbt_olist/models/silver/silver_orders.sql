-- models/silver/silver_orders.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_orders_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(order_id AS VARCHAR) AS order_id
        , CAST(customer_id AS VARCHAR) AS customer_id
        , CAST(order_status AS VARCHAR) AS order_status
        , CAST(order_purchase_timestamp AS TIMESTAMP) AS purchase_timestamp
        , CAST(order_approved_at AS TIMESTAMP) AS approved_at
        , CAST(order_delivered_carrier_date AS TIMESTAMP) AS delivered_to_carrier_at
        , CAST(order_delivered_customer_date AS TIMESTAMP) AS delivered_to_customer_at
        , CAST(order_estimated_delivery_date AS TIMESTAMP) AS estimated_delivery_at
    FROM source_data

)

SELECT * FROM renamed_and_casted