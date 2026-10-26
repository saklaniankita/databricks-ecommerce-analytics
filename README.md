# databricks-ecommerce-analytics
A portfolio project implementing a scalable Medallion data architecture, dimensional modeling, and customer analytics in Databricks SQL.
1. **Bronze Layer (`01_bronze_ingestion.sql`):** Stores raw, uncleaned ingestion tables (`bronze_customers`, `bronze_products`, `bronze_orders`) with explicit schema definitions.
2. **Silver Layer (`02_silver_cleaning.sql`):** Enforces data hygiene, proper data types, string trimming, null filtering, and programmatic deduplication using `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`.
3. **Gold Layer (`03_gold_analytics.sql`):** Models the cleaned data into a **Star Schema** (`gold_fact_orders`, `gold_dim_customers`, `gold_dim_products`) and computes advanced analytics.

---

## 🛠️ Tech Stack & Skills Demonstrated

* **Platform:** Databricks SQL, Delta Lake
* **Language:** SQL (ANSI / Spark SQL)
* **Data Modeling:** Dimensional Modeling (Star Schema), Medallion Architecture
* **Data Quality:** Programmatic Deduplication, String Cleaning, Strict Type Casting, CTEs, Window Functions (`ROW_NUMBER`, `NTILE`)
* **Business Analytics:** Recency-Frequency-Monetary (RFM) Segmentation, Monthly Cohort Retention Analysis

---

## 📂 Repository Structure

```text
├── sql/
│   ├── 01_bronze_ingestion.sql   # Raw table creation & initial schema definition
│   ├── 02_silver_cleaning.sql    # Data cleaning, deduplication, & type conversion
│   └── 03_gold_analytics.sql     # Star schema dimensions/facts & advanced analytics
└── README.md                     # Project documentation
