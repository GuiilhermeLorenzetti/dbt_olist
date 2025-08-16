-- models/silver/silver_product_category_translation.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'product_category_name_translation') }}

),

renamed_and_casted AS (

    SELECT
        CAST(product_category_name AS VARCHAR) AS product_category_name
        , CAST(product_category_name_english AS VARCHAR) AS product_category_name_english
    FROM source_data

)

SELECT * FROM renamed_and_casted