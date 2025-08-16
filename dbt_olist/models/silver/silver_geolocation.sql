-- models/silver/silver_geolocation.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_geolocation_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(geolocation_zip_code_prefix AS STRING) AS zip_code_prefix
        , CAST(geolocation_lat AS NUMERIC) AS latitude
        , CAST(geolocation_lng AS NUMERIC) AS longitude
        , CAST(geolocation_city AS STRING) AS city
        , CAST(geolocation_state AS STRING) AS state
    FROM source_data

)

SELECT * FROM renamed_and_casted