# Ingestão de Dados - Projeto DBT Olist

Este diretório contém os scripts e arquivos necessários para a ingestão dos dados do dataset Brazilian E-commerce da Olist.

## 📋 Visão Geral

O processo de ingestão é responsável por:
1. **Download automático** do dataset do Kaggle
2. **Preparação** dos arquivos CSV
3. **Carregamento** dos dados como seeds no projeto dbt

## 📁 Estrutura do Diretório

```
data_raw/
├── get_data_kaggle.py    # Script principal de download
├── get_data/            # Pasta temporária para arquivos baixados
└── README.md            # Esta documentação
```

## 📊 Dataset Baixado

### Dataset: Brazilian E-commerce Public Dataset by Olist

**Fonte**: [Kaggle - Brazilian E-commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Conteúdo**: 9 arquivos CSV com dados de e-commerce brasileiro

**Arquivos**:
1. `olist_customers_dataset.csv` - Dados dos clientes
2. `olist_sellers_dataset.csv` - Dados dos vendedores
3. `olist_products_dataset.csv` - Catálogo de produtos
4. `olist_orders_dataset.csv` - Pedidos realizados
5. `olist_order_items_dataset.csv` - Itens dos pedidos
6. `olist_order_payments_dataset.csv` - Pagamentos
7. `olist_order_reviews_dataset.csv` - Avaliações
8. `olist_geolocation_dataset.csv` - Dados geográficos
9. `product_category_name_translation.csv` - Tradução de categorias

## 🔄 Fluxo de Dados

### 1. Download
- Script baixa o dataset do Kaggle
- Arquivos são extraídos na pasta `get_data/`

### 2. Preparação
- Arquivos CSV são organizados
- Estrutura é validada

### 3. Carregamento
- Arquivos são copiados para `dbt_olist/seeds/`
- Seeds são carregados no banco de dados via dbt