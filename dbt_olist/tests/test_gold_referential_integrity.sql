-- Referential integrity test for the Gold layer
-- Validates if relationships between gold tables are correct

-- 1. Verify if all customers in dim_customers have at least one order
SELECT 
    'dim_customers_without_orders' as issue_type,
    dc.customer_unique_id,
    'customer_unique_id' as field_name,
    'Customer in dim_customers without corresponding orders' as description
FROM {{ ref('dim_customers') }} dc
LEFT JOIN (
    SELECT DISTINCT c.customer_unique_id
    FROM {{ ref('fct_order_details') }} fod
    JOIN {{ ref('silver_orders') }} o ON fod.order_id = o.order_id
    JOIN {{ ref('silver_customers') }} c ON o.customer_id = c.customer_id
) orders ON dc.customer_unique_id = orders.customer_unique_id
WHERE orders.customer_unique_id IS NULL

UNION ALL

-- 2. Verify if all orders in fct_order_details have a corresponding customer
SELECT 
    'fct_order_details_without_customer' as issue_type,
    fod.order_id,
    'order_id' as field_name,
    'Order in fct_order_details without corresponding customer' as description
FROM {{ ref('fct_order_details') }} fod
LEFT JOIN {{ ref('silver_orders') }} o ON fod.order_id = o.order_id
LEFT JOIN {{ ref('silver_customers') }} c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

-- 3. Verify if payment values are consistent between fct_order_details and silver_order_payments
SELECT 
    'payment_value_inconsistency' as issue_type,
    fod.order_id,
    'order_id' as field_name,
    'Inconsistent payment value between fct_order_details and silver_order_payments' as description
FROM {{ ref('fct_order_details') }} fod
LEFT JOIN (
    SELECT 
        order_id,
        SUM(payment_value) as total_payment_value
    FROM {{ ref('silver_order_payments') }}
    GROUP BY order_id
) payments ON fod.order_id = payments.order_id
WHERE ABS(fod.total_payment_value - COALESCE(payments.total_payment_value, 0)) > 0.01

UNION ALL

-- 4. Verify if review scores are consistent between fct_order_details and silver_order_reviews
SELECT 
    'review_score_inconsistency' as issue_type,
    fod.order_id,
    'order_id' as field_name,
    'Inconsistent review score between fct_order_details and silver_order_reviews' as description
FROM {{ ref('fct_order_details') }} fod
LEFT JOIN (
    SELECT 
        order_id,
        AVG(review_score) as avg_review_score
    FROM {{ ref('silver_order_reviews') }}
    GROUP BY order_id
) reviews ON fod.order_id = reviews.order_id
WHERE 
    fod.average_review_score IS NOT NULL 
    AND reviews.avg_review_score IS NOT NULL
    AND ABS(fod.average_review_score - reviews.avg_review_score) > 0.01


UNION ALL

-- 5. Verify if there are no duplicates in fct_order_details
SELECT 
    'fct_order_details_duplicates' as issue_type,
    order_id,
    'order_id' as field_name,
    'Duplicate order in fct_order_details' as description
FROM (
    SELECT 
        order_id,
        COUNT(*) as cnt
    FROM {{ ref('fct_order_details') }}
    GROUP BY order_id
    HAVING COUNT(*) > 1
) duplicates
