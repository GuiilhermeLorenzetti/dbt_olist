-- models/silver/silver_customers.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_customers_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(customer_id AS VARCHAR) AS customer_id
        , CAST(customer_unique_id AS VARCHAR) AS customer_unique_id
        , CAST(customer_zip_code_prefix AS VARCHAR) AS customer_zip_code_prefix
        , CAST(customer_city AS VARCHAR) AS customer_city
        , CAST(customer_state AS VARCHAR) AS customer_state
    FROM source_data

)

SELECT * FROM renamed_and_casted