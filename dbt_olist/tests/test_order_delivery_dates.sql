-- Teste para validar que as datas de entrega seguem uma sequência lógica
-- approved_at deve ser posterior a purchase_timestamp
-- delivered_to_carrier_at deve ser posterior a approved_at
-- delivered_to_customer_at deve ser posterior a delivered_to_carrier_at

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
