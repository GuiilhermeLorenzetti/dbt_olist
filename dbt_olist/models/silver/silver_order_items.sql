-- models/silver/silver_order_items.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_order_items_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(order_id AS STRING) AS order_id
        , CAST(order_item_id AS INT64) AS order_item_id
        , CAST(product_id AS STRING) AS product_id
        , CAST(seller_id AS STRING) AS seller_id
        , CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_at
        , CAST(price AS NUMERIC) AS price
        , CAST(freight_value AS NUMERIC) AS freight_value
    FROM source_data

)

SELECT * FROM renamed_and_casted