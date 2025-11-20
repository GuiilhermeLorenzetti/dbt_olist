# Olist dbt Project - Data Build Tool Learning

## 📋 Overview

This is a project focused on learning and practicing **dbt (data build tool)**. The project uses the **Brazilian E-commerce** dataset from Olist as a data source to demonstrate fundamental dbt concepts, including transformations, tests, documentation, and data engineering best practices.

**⚠️ Important**: This project is for educational purposes only. The focus is on the dbt tool and not on data analysis. Some configured tests may fail due to issues in the data source, but this is intentional to demonstrate how dbt handles data of varying quality.

## 🏗️ Project Architecture

### Directory Structure
```
dbt_olist/
├── data_raw/                          # Data ingestion scripts
│   ├── get_data_kaggle.py            # Automatic dataset download
│   └── get_data/                     # Folder for temporary data
├── dbt_olist/                        # Main dbt project
│   ├── models/                       # Transformation models
│   │   ├── silver/                   # Silver Layer (cleaned data)
│   │   ├── gold/                     # Gold Layer (business data)
│   │   └── sources.yml               # Data sources definition
│   ├── seeds/                        # Reference data (CSV)
│   ├── tests/                        # Custom quality tests
│   ├── macros/                       # Reusable macros
│   ├── snapshots/                    # Change control
│   └── dbt_project.yml               # Project configuration
└── README.md                         # Main documentation
```

## 🔄 Data Flow

### 1. **Bronze Layer (Seeds)**
- **Source**: Brazilian E-commerce Dataset from Kaggle
- **Process**: Automatic download via `get_data_kaggle.py`
- **Storage**: CSV files in `seeds/` folder
- **Schema**: `bronze`
- **9 tables**: customers, sellers, products, orders, order_items, order_payments, order_reviews, geolocation, product_category_translation


### 2. **Silver Layer (Transformation)**
- **Objective**: Data cleaning, standardization, and typing
- **9 models**: 1:1 transformation of bronze tables
- **Materialization**: view

- **Schema**: `silver`
- **Transformations**: Type casting, column renaming, standardization

### 3. **Gold Layer (Presentation)**
- **Objective**: Business data ready for analysis
- **2 models**: `fct_order_details` and `dim_customers`
- **Materialization**: Tables
- **Schema**: `gold`
- **Logic**: Aggregations, complex joins, business metrics

## 📊 Implemented Models

### 🥈 Silver Layer
**9 basic transformation models:**

| Model | Description | Main Transformations |
|--------|-----------|---------------------------|
| `silver_customers` | Customers | Type casting to VARCHAR |
| `silver_sellers` | Sellers | Type casting to VARCHAR |
| `silver_products` | Products | Type casting and name correction |
| `silver_orders` | Orders | Type casting and renaming |
| `silver_order_items` | Items | Type casting for monetary values |
| `silver_order_payments` | Payments | Type casting for monetary values |
| `silver_order_reviews` | Reviews | Type casting and renaming |
| `silver_geolocation` | Geolocation | Type casting and renaming |
| `silver_product_category_translation` | Translations  | Type casting to VARCHAR |

### 🥇 Gold Layer
**2 business models:**

#### `fct_order_details`
- **Purpose**: Consolidated view of all orders
- **Metrics**: Total value, review scores, payments by type
- **Logic**: Join of orders, payments, and reviews

#### `dim_customers`
- **Purpose**: Consolidated profile by unique customer
- **Metrics**: Lifetime value, number of orders, first/last purchase
- **Logic**: Aggregation by `customer_unique_id`

## 🧪 Data Quality

### Implemented Tests
- **Basic Tests**: not_null, unique, accepted_values
- **Custom Tests**: 7 specific tests for data validation
- **Custom Macros**: 3 macros for reusable tests

### Custom Tests
1. `test_order_delivery_dates.sql` - Chronological sequence validation
2. `test_brazilian_states.sql` - Brazilian states validation
3. `test_orphaned_records.sql` - Orphaned records identification
4. `test_gold_data_quality.sql` - Gold data quality
5. `test_gold_referential_integrity.sql` - Referential integrity
6. `test_product_quality.sql` - Product data quality

### Custom Macros
- `test_positive_values.sql` - Positive values validation
- `test_string_length_equal.sql` - String length validation
- `test_not_null_proportion.sql` - Non-null values proportion validation


## 📖 Additional Resources

- [Official dbt Documentation](https://docs.getdbt.com/)
- [dbt Community](https://community.getdbt.com/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
