# Projeto DBT Olist - Aprendizado de Data Build Tool

## 📋 Visão Geral

Este é um projeto focado no aprendizado e prática do **dbt (data build tool)**. O projeto utiliza o dataset **Brazilian E-commerce** da Olist como fonte de dados para demonstrar conceitos fundamentais do dbt, incluindo transformações, testes, documentação e boas práticas de engenharia de dados.

**⚠️ Importante**: Este projeto tem fins exclusivamente educacionais. O foco está na ferramenta dbt e não na análise de dados. Alguns testes configurados podem falhar devido a problemas na fonte dos dados, mas isso é intencional para demonstrar como o dbt lida com dados de qualidade variável.

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
│   ├── seeds/                        # Dados de referência (CSV)
│   ├── tests/                        # Testes de qualidade customizados
│   ├── macros/                       # Macros reutilizáveis
│   ├── snapshots/                    # Controle de mudanças
│   └── dbt_project.yml               # Configuração do projeto
└── README.md                         # Documentação principal
```

## 🔄 Fluxo de Dados

### 1. **Camada Bronze (Seeds)**
- **Fonte**: Dataset Brazilian E-commerce do Kaggle
- **Processo**: Download automático via `get_data_kaggle.py`
- **Armazenamento**: Arquivos CSV na pasta `seeds/`
- **Schema**: `bronze`
- **9 tabelas**: customers, sellers, products, orders, order_items, order_payments, order_reviews, geolocation, product_category_translation

### 2. **Camada Silver (Transformação)**
- **Objetivo**: Limpeza, padronização e tipagem dos dados
- **9 modelos**: Transformação 1:1 das tabelas bronze
- **Materialização**: view
- **Schema**: `silver`
- **Transformações**: Cast de tipos, renomeação de colunas, padronização

### 3. **Camada Gold (Apresentação)**
- **Objetivo**: Dados de negócio prontos para análise
- **2 modelos**: `fct_order_details` e `dim_customers`
- **Materialização**: Tables
- **Schema**: `gold`
- **Lógica**: Agregações, junções complexas, métricas de negócio

## 📊 Modelos Implementados

### 🥈 Camada Silver
**9 modelos de transformação básica:**

| Modelo | Descrição | Principais Transformações |
|--------|-----------|---------------------------|
| `silver_customers` | Clientes | Cast de tipos para VARCHAR |
| `silver_sellers` | Vendedores | Cast de tipos para VARCHAR |
| `silver_products` | Produtos | Cast de tipos e correção de nomes |
| `silver_orders` | Pedidos | Cast de tipos e renomeação |
| `silver_order_items` | Itens | Cast de tipos para valores monetários |
| `silver_order_payments` | Pagamentos | Cast de tipos para valores monetários |
| `silver_order_reviews` | Avaliações | Cast de tipos e renomeação |
| `silver_geolocation` | Geolocalização | Cast de tipos e renomeação |
| `silver_product_category_translation` | Traduções  | Cast de tipos para VARCHAR |

### 🥇 Camada Gold
**2 modelos de negócio:**

#### `fct_order_details`
- **Propósito**: Visão consolidada de todos os pedidos
- **Métricas**: Valor total, scores de avaliação, pagamentos por tipo
- **Lógica**: Junção de pedidos, pagamentos e avaliações

#### `dim_customers`
- **Propósito**: Perfil consolidado por cliente único
- **Métricas**: Lifetime value, número de pedidos, primeira/última compra
- **Lógica**: Agregação por `customer_unique_id`

## 🧪 Qualidade de Dados

### Testes Implementados
- **Testes Básicos**: not_null, unique, accepted_values
- **Testes Customizados**: 7 testes específicos para validação de dados
- **Macros Customizados**: 3 macros para testes reutilizáveis

### Testes Customizados
1. `test_order_delivery_dates.sql` - Validação de sequência cronológica
2. `test_brazilian_states.sql` - Validação de UFs brasileiras
3. `test_orphaned_records.sql` - Identificação de registros órfãos
4. `test_gold_data_quality.sql` - Qualidade dos dados gold
5. `test_gold_referential_integrity.sql` - Integridade referencial
6. `test_product_quality.sql` - Qualidade dos dados de produtos

### Macros Customizados
- `test_positive_values.sql` - Validação de valores positivos
- `test_string_length_equal.sql` - Validação de comprimento de strings
- `test_not_null_proportion.sql` - Validação de proporção de valores não nulos


## 📖 Recursos Adicionais

- [Documentação oficial do dbt](https://docs.getdbt.com/)
- [dbt Community](https://community.getdbt.com/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
