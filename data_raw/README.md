# Data Ingestion - DBT Olist Project

This directory contains the scripts and files necessary for ingesting data from the Brazilian E-commerce dataset by Olist.

## 📋 Overview

The ingestion process is responsible for:
1. **Automatic download** of the dataset from Kaggle
2. **Preparation** of CSV files
3. **Loading** of data as seeds in the dbt project

## 📁 Directory Structure

```
data_raw/
├── get_data_kaggle.py    # Main download script
├── get_data/            # Temporary folder for downloaded files
└── README.md            # This documentation
```

## 📊 Downloaded Dataset

### Dataset: Brazilian E-commerce Public Dataset by Olist

**Source**: [Kaggle - Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Content**: 9 CSV files with Brazilian e-commerce data

**Files**:
1. `olist_customers_dataset.csv` - Customer data
2. `olist_sellers_dataset.csv` - Seller data
3. `olist_products_dataset.csv` - Product catalog
4. `olist_orders_dataset.csv` - Placed orders
5. `olist_order_items_dataset.csv` - Order items
6. `olist_order_payments_dataset.csv` - Payments
7. `olist_order_reviews_dataset.csv` - Reviews
8. `olist_geolocation_dataset.csv` - Geographic data
9. `product_category_name_translation.csv` - Category translation

## 🔄 Data Flow

### 1. Download
- Script downloads the dataset from Kaggle
- Files are extracted into the `get_data/` folder

### 2. Preparation
- CSV files are organized
- Structure is validated

### 3. Loading
- Files are copied to `dbt_olist/seeds/`
- Seeds are loaded into the database via dbt