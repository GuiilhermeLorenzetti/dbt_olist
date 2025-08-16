-- models/silver/silver_order_payments.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_order_payments_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(order_id AS VARCHAR) AS order_id
        , CAST(payment_sequential AS INTEGER) AS payment_sequential
        , CAST(payment_type AS VARCHAR) AS payment_type
        , CAST(payment_installments AS INTEGER) AS payment_installments
        , CAST(payment_value AS DECIMAL(10,2)) AS payment_value
    FROM source_data

)

SELECT * FROM renamed_and_casted