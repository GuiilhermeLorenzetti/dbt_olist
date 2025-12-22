-- models/silver/silver_geolocation.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_geolocation_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(geolocation_zip_code_prefix AS VARCHAR) AS zip_code_prefix
        , CAST(geolocation_lat AS DECIMAL(12,8)) AS latitude
        , CAST(geolocation_lng AS DECIMAL(12,8)) AS longitude
        , CAST(geolocation_city AS VARCHAR) AS city
        , CAST(geolocation_state AS VARCHAR) AS state
    FROM source_data

)

SELECT * FROM renamed_and_casted