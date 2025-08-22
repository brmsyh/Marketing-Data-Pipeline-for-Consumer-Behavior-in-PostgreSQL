# **Marketing Data Pipeline for Consumer Behavior (Pandas -> PostgreSQL, 3NF)**

## Overview
This project turns a raw consumer-behavior CSV into an analytics-ready relational model for **marketing**: we standardize columns, fix data types (e.g., currency to numeric, timestamps to datetime), engineer a **purchase-amount band**, and design a **3NF** warehouse with one **fact** table and five **dimensions** (time, gender, payment method, product category, location). The SQL script then creates tables, loads CSVs via `COPY`, and runs two validation queries for quick sanity checks. The end result is a query-ready schema for segmentation, KPI rollups, and campaign analytics.

## What’s in this folder
- **`Notebook.ipynb`** — end-to-end notebook (EDA, cleaning, normalization, CSV export, SQL generator).
- **`Consumer_Behavior_SQL.sql`** — ready-to-run DDL + `COPY` + test queries.

## Data source
- Public CSV (as used in the notebook):  
  `https://raw.githubusercontent.com/FTDS-learning-materials/phase-0/refs/heads/main/src/Consumer_Behavior_Analysis_Data(GC2Set2).csv`

## Quick start

### A) Run with the notebook
1. Open **`Notebook.ipynb`** and **Run All**:
   - Cleans/standardizes columns (e.g., cast `purchase_amount` to float, parse `time_of_purchase`).
   - Creates **`main_table`** (10 selected columns) and **`categorical_purchase_amount`** (low/mid/high).
   - Normalizes into **6 tables**: `main_fact` + 5 dimensions (time, gender, payment method, product category, location).
   - Exports CSVs to a local `tables/` folder and writes a SQL script.
2. Move the exported CSVs to your machine’s **`/tmp/`** directory (required for `COPY` paths below).
3. Continue with section **B)** to create the database and load data.

### B) Run the SQL script (PostgreSQL)
1. Create and connect to the database (first two commands of the script).
2. Execute the DDL to create **dimension** and **fact** tables:  
   - `dim_gender`, `dim_time`, `dim_payment_method`, `dim_product_category`, `dim_location`.
   - `main_fact` with foreign keys to all dimensions.
3. Load data from CSVs using `COPY` (place files in **`/tmp/`**).
4. Run the two **test queries** included at the bottom of the script to verify joins and metrics:  
   - (a) **Total Purchase Amount by Gender** filtered to **Age ≤ 30**.  
   - (b) **Avg/Min/Max Purchase Amount** by **Product Category**.

## Database schema (3NF)
- **Dimensions**
  - `dim_gender(gender_id, gender)` — normalized gender labels.  
  - `dim_time(time_id, time_of_purchase, date, year, month, day, hour)` — derived from purchase time.  
  - `dim_payment_method(payment_method_id, payment_method)` — payment channels used.  
  - `dim_product_category(product_category_id, product_category)` — product taxonomy.  
  - `dim_location(location_id, location)` — area or region information.  
- **Fact**
  - `main_fact(main_id, age, purchase_amount, categorical_purchase_amount, gender_id, time_id, payment_method_id, product_category_id, location_id)` with FKs to all dimensions.

## Deliverables & outputs
- A reproducible **notebook** that outputs:
  - Cleaned tables exported as CSVs (for each dimension + `main_fact`).
  - Two CSVs with **query results** mirroring the SQL test queries.
- A single **SQL script** that:
  - Creates all tables.
  - Loads CSVs via `COPY` from **`/tmp/`**.
  - Includes two validation queries.

## Suggested environment
- **Python**: 3.10+ (Pandas, NumPy, Jupyter) for running the notebook.
- **PostgreSQL**: 13+ (psql or pgAdmin) for running the SQL.

## Usage ideas (Marketing)
- Build **segmentation** by product category, payment method, channel, device, age band, discount sensitivity.
- Monitor **KPIs** (AOV, revenue, return %, repeat rate), and run **A/B test** readouts.
- Feed BI tools (e.g., Tableau, Power BI) via simple SQL views on this schema.

## Final notes
- Copy all CSVs exported by the notebook from `tables/` to **`/tmp/`** before executing the `COPY` statements in PostgreSQL.
