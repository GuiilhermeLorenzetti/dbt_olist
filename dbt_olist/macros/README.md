# Macros Customizados - Projeto DBT Olist

Este diretório contém macros customizados reutilizáveis para testes e transformações específicas do projeto.

## 📋 Visão Geral

Os macros customizados demonstram como criar código SQL reutilizável no dbt, permitindo:
- **Reutilização** de lógica comum
- **Padronização** de testes
- **Manutenibilidade** do código
- **Flexibilidade** para casos específicos

## 🔧 Macros Implementados

### 1. `test_positive_values.sql`

**Propósito**: Valida que valores numéricos são positivos

**Parâmetros**:
- `model`: Modelo a ser testado
- `column_name`: Nome da coluna a ser validada

**Uso**:
```sql
{{ test_positive_values(model, column_name) }}
```

**Exemplo**:
```yaml
# Em schema.yml
columns:
  - name: price
    tests:
      - test_positive_values
```

**Aplicação**: Preços, fretes, pagamentos, dimensões de produtos

### 2. `test_string_length_equal.sql`

**Propósito**: Valida que strings têm comprimento específico

**Parâmetros**:
- `model`: Modelo a ser testado
- `column_name`: Nome da coluna a ser validada
- `expected_length`: Comprimento esperado

**Uso**:
```sql
{{ test_string_length_equal(model, column_name, expected_length) }}
```

**Exemplo**:
```yaml
# Em schema.yml
columns:
  - name: customer_zip_code_prefix
    tests:
      - test_string_length_equal:
          expected_length: 5
```

**Aplicação**: CEPs (5 dígitos), estados (2 caracteres)

### 3. `test_not_null_proportion.sql`

**Propósito**: Valida que uma proporção mínima de valores não é nula

**Parâmetros**:
- `model`: Modelo a ser testado
- `column_name`: Nome da coluna a ser validada
- `min_proportion`: Proporção mínima (0.0 a 1.0)

**Uso**:
```sql
{{ test_not_null_proportion(model, column_name, min_proportion) }}
```

**Exemplo**:
```yaml
# Em schema.yml
columns:
  - name: product_description
    tests:
      - test_not_null_proportion:
          min_proportion: 0.8
```