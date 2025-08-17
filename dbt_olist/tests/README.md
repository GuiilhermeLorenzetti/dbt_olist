# Testes de Qualidade de Dados - Projeto DBT Olist

Este diretório contém todos os testes customizados para validar a qualidade dos dados no projeto dbt Olist. Os testes demonstram como o dbt pode ser usado para garantir a qualidade e integridade dos dados em diferentes camadas.

**⚠️ Importante**: Este projeto tem fins didáticos. Alguns testes podem falhar devido a problemas na fonte dos dados, demonstrando como o dbt lida com dados de qualidade variável.

## 📋 Visão Geral dos Testes

### Testes Básicos (Schema.yml)
Testes padrão do dbt aplicados nas definições de schema:

- **not_null**: Validação de campos obrigatórios
- **unique**: Validação de chaves primárias
- **accepted_values**: Validação de valores permitidos

### Testes Customizados (SQL)
Testes específicos escritos em SQL para validações mais complexas:

- **Validação de Datas**: Sequência cronológica de eventos
- **Validação Geográfica**: Estados brasileiros válidos
- **Validação de Integridade**: Registros órfãos e referências quebradas
- **Validação de Qualidade**: Dados de produtos e métricas de negócio

### Macros Customizados
Funções reutilizáveis para testes específicos:

- **test_positive_values**: Validação de valores positivos
- **test_string_length_equal**: Validação de comprimento de strings
- **test_not_null_proportion**: Validação de proporção de valores não nulos

## 🧪 Testes Customizados Implementados

### 1. `test_order_delivery_dates.sql`
**Propósito**: Valida a sequência cronológica das datas de entrega

**Validações**:
- `approved_at` deve ser posterior a `purchase_timestamp`
- `delivered_to_carrier_at` deve ser posterior a `approved_at`
- `delivered_to_customer_at` deve ser posterior a `delivered_to_carrier_at`

**Aplicação**: Camada Silver - `silver_orders`

### 2. `test_brazilian_states.sql`
**Propósito**: Valida que os estados são UFs brasileiras válidas

**Validações**:
- Estados devem estar na lista oficial de UFs brasileiras
- Aplicado em todas as tabelas com dados de localização

**Aplicação**: Camadas Silver e Gold

### 3. `test_orphaned_records.sql`
**Propósito**: Identifica registros órfãos (referências quebradas)


**Aplicação**: Camada Silver

### 4. `test_gold_data_quality.sql`
**Propósito**: Valida a qualidade dos dados na camada Gold

**Validações**:
- Valores monetários positivos
- Scores de avaliação entre 1 e 5
- Integridade de chaves primárias

**Aplicação**: Camada Gold

### 5. `test_gold_referential_integrity.sql`
**Propósito**: Valida a integridade referencial entre modelos Gold

**Validações**:
- Relacionamentos entre `fct_order_details` e `dim_customers`
- Consistência de chaves estrangeiras
- Dados agregados coerentes

**Aplicação**: Camada Gold

### 6. `test_product_quality.sql`
**Propósito**: Valida a qualidade dos dados de produtos

**Validações**:
- Nomes com pelo menos 3 caracteres
- Descrições com pelo menos 10 caracteres
- Produtos com pelo menos 1 foto
- Dimensões não zero

**Aplicação**: Camada Silver - `silver_products`

## 🔧 Macros Customizados

### `test_positive_values.sql`
**Propósito**: Valida que valores numéricos são positivos

**Uso**:
```sql
{{ test_positive_values(model, column_name) }}
```

**Aplicação**: Preços, fretes, pagamentos, dimensões de produtos

### `test_string_length_equal.sql`
**Propósito**: Valida que strings têm comprimento específico

**Uso**:
```sql
{{ test_string_length_equal(model, column_name, expected_length) }}
```

**Aplicação**: CEPs (5 dígitos), estados (2 caracteres)

### `test_not_null_proportion.sql`
**Propósito**: Valida que uma proporção mínima de valores não é nula

**Uso**:
```sql
{{ test_not_null_proportion(model, column_name, min_proportion) }}
```

**Aplicação**: Campos opcionais que devem ter preenchimento mínimo

## 📊 Cobertura de Testes

### Camada Bronze (Seeds)
- **not_null**: Campos obrigatórios
- **unique**: Chaves primárias

### Camada Silver
- **Testes Básicos**: not_null, unique, relationships, accepted_values
- **Testes Customizados**: 4 testes específicos
- **Macros**: Validação de valores positivos e comprimento de strings

### Camada Gold
- **Testes Customizados**: 2 testes específicos
- **Validações**: Qualidade de dados e integridade referencial