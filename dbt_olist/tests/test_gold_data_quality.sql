-- Testes de qualidade de dados para a camada Gold
-- Validações específicas para os modelos gold

-- 1. Teste para dim_customers - Validações de integridade
SELECT 
    'dim_customers_invalid_lifetime_value' as test_name,
    customer_unique_id,
    lifetime_value,
    'Lifetime value deve ser maior ou igual a zero' as issue_description
FROM {{ ref('dim_customers') }}
WHERE lifetime_value < 0

UNION ALL

SELECT 
    'dim_customers_invalid_order_count' as test_name,
    customer_unique_id,
    number_of_orders,
    'Número de pedidos deve ser maior que zero' as issue_description
FROM {{ ref('dim_customers') }}
WHERE number_of_orders <= 0

UNION ALL

SELECT 
    'dim_customers_invalid_dates' as test_name,
    customer_unique_id,
    first_order_timestamp,
    'Primeira ordem deve ser anterior ou igual à última ordem' as issue_description
FROM {{ ref('dim_customers') }}
WHERE first_order_timestamp > last_order_timestamp

UNION ALL

-- 2. Teste para fct_order_details - Validações de integridade
SELECT 
    'fct_order_details_invalid_payment_values' as test_name,
    order_id,
    total_payment_value,
    'Valor total de pagamento deve ser maior que zero' as issue_description
FROM {{ ref('fct_order_details') }}
WHERE total_payment_value <= 0

UNION ALL

SELECT 
    'fct_order_details_payment_sum_mismatch' as test_name,
    order_id,
    total_payment_value,
    'Soma dos métodos de pagamento deve igualar o total' as issue_description
FROM {{ ref('fct_order_details') }}
WHERE ABS(total_payment_value - (credit_card_payment_value + boleto_payment_value + voucher_payment_value + others_payment_value)) > 0.01

UNION ALL

SELECT 
    'fct_order_details_invalid_review_score' as test_name,
    order_id,
    average_review_score,
    'Score de avaliação deve estar entre 1 e 5' as issue_description
FROM {{ ref('fct_order_details') }}
WHERE average_review_score IS NOT NULL 
  AND (average_review_score < 1 OR average_review_score > 5)

UNION ALL

-- 3. Teste para validar sequência temporal dos pedidos
SELECT 
    'fct_order_details_invalid_date_sequence' as test_name,
    order_id,
    purchase_timestamp,
    'Datas devem seguir sequência lógica: purchase -> approved -> delivered' as issue_description
FROM {{ ref('fct_order_details') }}
WHERE 
    (approved_at IS NOT NULL AND approved_at < purchase_timestamp)
    OR (delivered_to_carrier_at IS NOT NULL AND approved_at IS NOT NULL AND delivered_to_carrier_at < approved_at)
    OR (delivered_to_customer_at IS NOT NULL AND delivered_to_carrier_at IS NOT NULL AND delivered_to_customer_at < delivered_to_carrier_at)

UNION ALL

-- 4. Teste para validar consistência entre dim_customers e fct_order_details
SELECT 
    'customer_order_consistency_mismatch' as test_name,
    dc.customer_unique_id,
    dc.lifetime_value,
    'Valor total do cliente deve ser igual à soma dos pedidos' as issue_description
FROM {{ ref('dim_customers') }} dc
LEFT JOIN (
    SELECT 
        c.customer_unique_id,
        SUM(fod.total_payment_value) as calculated_lifetime_value
    FROM {{ ref('fct_order_details') }} fod
    JOIN {{ ref('silver_orders') }} o ON fod.order_id = o.order_id
    JOIN {{ ref('silver_customers') }} c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
) calc ON dc.customer_unique_id = calc.customer_unique_id
WHERE ABS(dc.lifetime_value - COALESCE(calc.calculated_lifetime_value, 0)) > 0.01
