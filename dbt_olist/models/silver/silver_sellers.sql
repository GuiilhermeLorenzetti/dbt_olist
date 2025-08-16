-- models/silver/silver_sellers.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_sellers_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(seller_id AS VARCHAR) AS seller_id
        , CAST(seller_zip_code_prefix AS VARCHAR) AS seller_zip_code_prefix
        , CAST(seller_city AS VARCHAR) AS seller_city
        , CAST(seller_state AS VARCHAR) AS seller_state
    FROM source_data

)

SELECT * FROM renamed_and_casted