# Data Quality Tests - Olist dbt Project

This directory contains all custom tests to validate data quality in the Olist dbt project. The tests demonstrate how dbt can be used to ensure data quality and integrity across different layers.

**⚠️ Important**: This project is for educational purposes. Some tests may fail due to issues in the data source, demonstrating how dbt handles data of varying quality.

## 📋 Tests Overview

### Basic Tests (Schema.yml)
Standard dbt tests applied in schema definitions:

- **not_null**: Mandatory fields validation
- **unique**: Primary keys validation
- **accepted_values**: Allowed values validation

### Custom Tests (SQL)
Specific tests written in SQL for more complex validations:

- **Date Validation**: Chronological sequence of events
- **Geographic Validation**: Valid Brazilian states
- **Integrity Validation**: Orphaned records and broken references
- **Quality Validation**: Product data and business metrics

### Custom Macros
Reusable functions for specific tests:

- **test_positive_values**: Positive values validation
- **test_string_length_equal**: String length validation
- **test_not_null_proportion**: Non-null values proportion validation

## 🧪 Implemented Custom Tests

### 1. `test_order_delivery_dates.sql`
**Purpose**: Validates chronological sequence of delivery dates

**Validations**:
- `approved_at` must be after `purchase_timestamp`
- `delivered_to_carrier_at` must be after `approved_at`
- `delivered_to_customer_at` must be after `delivered_to_carrier_at`

**Application**: Silver Layer - `silver_orders`

### 2. `test_brazilian_states.sql`
**Purpose**: Validates that states are valid Brazilian UFs

**Validations**:
- States must be in the official list of Brazilian UFs
- Applied in all tables with location data

**Application**: Silver and Gold Layers

### 3. `test_orphaned_records.sql`
**Purpose**: Identifies orphaned records (broken references)


**Application**: Silver Layer

### 4. `test_gold_data_quality.sql`
**Purpose**: Validates data quality in the Gold layer

**Validations**:
- Positive monetary values
- Review scores between 1 and 5
- Primary key integrity

**Application**: Gold Layer

### 5. `test_gold_referential_integrity.sql`
**Purpose**: Validates referential integrity between Gold models

**Validations**:
- Relationships between `fct_order_details` and `dim_customers`
- Foreign key consistency
- Consistent aggregated data

**Application**: Gold Layer

### 6. `test_product_quality.sql`
**Purpose**: Validates product data quality

**Validations**:
- Names with at least 3 characters
- Descriptions with at least 10 characters
- Products with at least 1 photo
- Non-zero dimensions

**Application**: Silver Layer - `silver_products`

## 🔧 Custom Macros

### `test_positive_values.sql`
**Purpose**: Validates that numeric values are positive

**Usage**:
```sql
{{ test_positive_values(model, column_name) }}
```

**Application**: Prices, freights, payments, product dimensions

### `test_string_length_equal.sql`
**Purpose**: Validates that strings have specific length

**Usage**:
```sql
{{ test_string_length_equal(model, column_name, expected_length) }}
```

**Application**: Zip codes (5 digits), states (2 characters)

### `test_not_null_proportion.sql`
**Purpose**: Validates that a minimum proportion of values is not null

**Usage**:
```sql
{{ test_not_null_proportion(model, column_name, min_proportion) }}
```

**Application**: Optional fields that must have minimum population

## 📊 Test Coverage

### Bronze Layer (Seeds)
- **not_null**: Mandatory fields
- **unique**: Primary keys

### Silver Layer
- **Basic Tests**: not_null, unique, relationships, accepted_values
- **Custom Tests**: 4 specific tests
- **Macros**: Positive values and string length validation

### Gold Layer
- **Custom Tests**: 2 specific tests
- **Validations**: Data quality and referential integrity