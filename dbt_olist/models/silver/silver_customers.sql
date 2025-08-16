-- models/silver/silver_customers.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_customers_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(customer_id AS STRING) AS customer_id
        , CAST(customer_unique_id AS STRING) AS customer_unique_id
        , CAST(customer_zip_code_prefix AS STRING) AS customer_zip_code_prefix
        , CAST(customer_city AS STRING) AS customer_city
        , CAST(customer_state AS STRING) AS customer_state
    FROM source_data

)

SELECT * FROM renamed_and_casted