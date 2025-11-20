# Custom Macros - Olist dbt Project

This directory contains reusable custom macros for specific project tests and transformations.

## 📋 Overview

Custom macros demonstrate how to create reusable SQL code in dbt, allowing:
- **Reuse** of common logic
- **Standardization** of tests
- **Maintainability** of code
- **Flexibility** for specific cases

## 🔧 Implemented Macros

### 1. `test_positive_values.sql`

**Purpose**: Validates that numeric values are positive

**Parameters**:
- `model`: Model to be tested
- `column_name`: Name of the column to be validated

**Usage**:
```sql
{{ test_positive_values(model, column_name) }}
```

**Example**:
```yaml
# In schema.yml
columns:
  - name: price
    tests:
      - test_positive_values
```

**Application**: Prices, freights, payments, product dimensions

### 2. `test_string_length_equal.sql`

**Purpose**: Validates that strings have specific length

**Parameters**:
- `model`: Model to be tested
- `column_name`: Name of the column to be validated
- `expected_length`: Expected length

**Usage**:
```sql
{{ test_string_length_equal(model, column_name, expected_length) }}
```

**Example**:
```yaml
# In schema.yml
columns:
  - name: customer_zip_code_prefix
    tests:
      - test_string_length_equal:
          expected_length: 5
```

**Application**: Zip codes (5 digits), states (2 characters)

### 3. `test_not_null_proportion.sql`

**Purpose**: Validates that a minimum proportion of values is not null

**Parameters**:
- `model`: Model to be tested
- `column_name`: Name of the column to be validated
- `min_proportion`: Minimum proportion (0.0 to 1.0)

**Usage**:
```sql
{{ test_not_null_proportion(model, column_name, min_proportion) }}
```

**Example**:
```yaml
# In schema.yml
columns:
  - name: product_description
    tests:
      - test_not_null_proportion:
          min_proportion: 0.8
```