## 📋 Visão Geral

Este projeto implementa uma solução de **Data Engineering** utilizando **dbt (data build tool)** para análise de dados do dataset **Brazilian E-commerce** da Olist. O projeto segue a arquitetura **Medallion Architecture** (Bronze → Silver → Gold) para transformar dados brutos em insights acionáveis.

## 🏗️ Arquitetura do Projeto

### Estrutura de Diretórios
```
dbt_olist/
├── data_raw/                          # Scripts de ingestão de dados
│   ├── get_data_kaggle.py            # Download automático do dataset
│   └── get_data/                     # Pasta para dados temporários
├── dbt_olist/                        # Projeto dbt principal
│   ├── models/                       # Modelos de transformação
│   │   ├── silver/                   # Camada Silver (dados limpos)
│   │   ├── gold/                     # Camada Gold (dados de negócio)
│   │   └── sources.yml               # Definição das fontes de dados
│   ├── seeds/                        # Dados de referência
│   ├── tests/                        # Testes de qualidade
│   ├── macros/                       # Macros reutilizáveis
│   ├── snapshots/                    # Controle de mudanças
│   └── dbt_project.yml               # Configuração do projeto
├── logs/                             # Logs de execução
└── .venv/                           # Ambiente virtual Python
```

## 🔄 Fluxo de Dados (Data Pipeline)

### 1. **Ingestão (Bronze Layer)**
- **Fonte**: Dataset Brazilian E-commerce do Kaggle
- **Script**: `data_raw/get_data_kaggle.py`
- **Processo**: Download automático via Kaggle API
- **Armazenamento**: Arquivos CSV na pasta `seeds/`

### 2. **Transformação (Silver Layer)**
- **Objetivo**: Limpeza, padronização e tipagem dos dados
- **Modelos**: 9 tabelas silver com dados limpos
- **Materialização**: Tables (persistentes)
- **Schema**: `silver`

### 3. **Apresentação (Gold Layer)**
- **Objetivo**: Dados de negócio prontos para análise
- **Modelos**: 3 tabelas gold com métricas agregadas
- **Materialização**: Views (otimizadas para consulta)
- **Schema**: `gold`

## 📊 Modelos de Dados

### 🥉 Camada Bronze (Raw Data)
**Dados brutos 1:1 com os arquivos CSV originais**

A camada Bronze representa os dados exatamente como foram baixados do Kaggle, sem nenhuma transformação. Cada arquivo CSV é carregado diretamente no banco de dados mantendo sua estrutura original.

**9 tabelas de dados brutos:**
- `olist_customers_dataset` - Dados dos clientes
- `olist_sellers_dataset` - Dados dos vendedores  
- `olist_products_dataset` - Catálogo de produtos
- `olist_orders_dataset` - Pedidos realizados
- `olist_order_items_dataset` - Itens dos pedidos
- `olist_order_payments_dataset` - Pagamentos
- `olist_order_reviews_dataset` - Avaliações
- `olist_geolocation_dataset` - Dados geográficos
- `product_category_name_translation` - Tradução de categorias

**Características:**
- ✅ Dados originais preservados
- ✅ Estrutura 1:1 com arquivos CSV
- ✅ Sem transformações ou limpezas
- ✅ Fonte única da verdade

### 🥈 Camada Silver (Clean Data)
**Dados limpos e padronizados 1:1 com Bronze**

A camada Silver aplica transformações básicas de limpeza e padronização, mantendo a relação 1:1 com as tabelas Bronze, mas agora com dados mais confiáveis e tipados corretamente.

**9 modelos de transformação:**

| Modelo | Descrição | Principais Transformações |
|--------|-----------|---------------------------|
| `silver_customers` | Clientes limpos | Cast de tipos, validação de IDs |
| `silver_sellers` | Vendedores limpos | Cast de tipos, validação de IDs |
| `silver_products` | Produtos limpos | Cast de tipos, validação de dimensões |
| `silver_orders` | Pedidos limpos | Cast de timestamps, validação de status |
| `silver_order_items` | Itens limpos | Cast de valores monetários |
| `silver_order_payments` | Pagamentos limpos | Agregação por tipo de pagamento |
| `silver_order_reviews` | Avaliações limpas | Cast de timestamps, validação de scores |
| `silver_geolocation` | Geolocalização limpa | Cast de coordenadas |
| `silver_product_category_translation` | Traduções limpas | Validação de categorias |

**Transformações Aplicadas:**
- 🔄 Cast de tipos de dados (VARCHAR, TIMESTAMP, DECIMAL)
- 🧹 Limpeza de valores nulos e inválidos
- ✅ Validação de integridade referencial
- 📝 Padronização de nomes de colunas
- 🎯 Garantia de qualidade dos dados

**3 modelos de negócio:**

#### 1. `fct_order_details` - Tabela Fato Principal
- **Propósito**: Visão consolidada de todos os pedidos
- **Métricas**: Valor total, tempo de entrega, scores de avaliação
- **Dimensões**: Cliente, produto, vendedor, localização
- **Lógica**: Junção de todas as tabelas silver com agregação de pagamentos

#### 2. `dim_customers` - Dimensão de Clientes
- **Propósito**: Perfil consolidado por cliente único
- **Métricas**: Lifetime value, número de pedidos, primeira compra
- **Lógica**: Agregação por `customer_unique_id`

#### 3. `agg_seller_performance` - Performance de Vendedores
- **Propósito**: Métricas de performance por vendedor
- **Métricas**: Receita total, número de pedidos, score médio
- **Filtro**: Apenas pedidos entregues (`delivered`)

**Regras de Negócio Implementadas:**
- 💰 Cálculo de receita total por pedido
- ⏱️ Cálculo de tempo de entrega em dias
- 📊 Agregação de métricas por cliente e vendedor
- 🎯 Filtros específicos (apenas pedidos entregues)
- 🔗 Junções complexas entre múltiplas tabelas
- 📈 Criação de dimensões para análise dimensional

## 🧪 Qualidade de Dados

### Testes Implementados
- **Not Null**: Validação de campos obrigatórios
- **Unique**: Validação de chaves primárias
- **Referential Integrity**: Validação de chaves estrangeiras
- **Custom Tests**: Testes específicos de negócio

### Documentação
- **Schema Documentation**: Descrição detalhada de todas as tabelas e colunas
- **Data Lineage**: Rastreabilidade completa das transformações
- **Business Logic**: Documentação das regras de negócio aplicadas
