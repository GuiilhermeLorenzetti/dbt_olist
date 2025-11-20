-- Test to validate that delivery dates follow a logical sequence
-- approved_at must be after purchase_timestamp
-- delivered_to_carrier_at must be after approved_at
-- delivered_to_customer_at must be after delivered_to_carrier_at

SELECT 
    order_id,
    purchase_timestamp,
    approved_at,
    delivered_to_carrier_at,
    delivered_to_customer_at
FROM {{ ref('silver_orders') }}
WHERE 
    (approved_at IS NOT NULL AND approved_at < purchase_timestamp)
    OR (delivered_to_carrier_at IS NOT NULL AND approved_at IS NOT NULL AND delivered_to_carrier_at < approved_at)
    OR (delivered_to_customer_at IS NOT NULL AND delivered_to_carrier_at IS NOT NULL AND delivered_to_customer_at < delivered_to_carrier_at)
