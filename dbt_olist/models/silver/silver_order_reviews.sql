-- models/silver/silver_order_reviews.sql

WITH source_data AS (

    SELECT * FROM {{ source('bronze', 'olist_order_reviews_dataset') }}

),

renamed_and_casted AS (

    SELECT
        CAST(review_id AS VARCHAR) AS review_id
        , CAST(order_id AS VARCHAR) AS order_id
        , CAST(review_score AS INTEGER) AS review_score
        , CAST(review_comment_title AS VARCHAR) AS review_comment_title
        , CAST(review_comment_message AS VARCHAR) AS review_comment_message
        , CAST(review_creation_date AS TIMESTAMP) AS review_creation_timestamp
        , CAST(review_answer_timestamp AS TIMESTAMP) AS review_answer_timestamp
    FROM source_data

)

SELECT * FROM renamed_and_casted