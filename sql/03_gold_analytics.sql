USE ecommerce_lakehouse;

-- ==========================================
-- 1. BUILD GOLD DIMENSION & FACT TABLES (Star Schema)
-- ==========================================

-- Gold Customer Dimension Table (Enriched with total metrics)
CREATE OR REPLACE TABLE gold_dim_customers AS
SELECT 
    c.customer_id,
    c.signup_date,
    c.country,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS lifetime_spend
FROM silver_customers c
LEFT JOIN silver_orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.signup_date, c.country;


-- Gold Product Dimension Table
CREATE OR REPLACE TABLE gold_dim_products AS
SELECT 
    product_id,
    category,
    price
FROM silver_products;


-- Gold Order Fact Table (Central transactional fact table)
CREATE OR REPLACE TABLE gold_fact_orders AS
SELECT 
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.total_amount,
    o.status,
    p.category AS product_category,
    c.country AS customer_country
FROM silver_orders o
LEFT JOIN silver_customers c ON o.customer_id = c.customer_id
LEFT JOIN silver_products p ON o.product_id = p.product_id;


-- ==========================================
-- 2. BUILD GOLD ANALYTICAL TABLES
-- ==========================================

-- RFM Customer Segmentation Table
CREATE OR REPLACE TABLE gold_rfm_segments AS
WITH customer_aggregates AS (
    SELECT 
        customer_id,
        DATEDIFF(CURRENT_DATE(), MAX(order_date)) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(total_amount) AS monetary
    FROM silver_orders
    GROUP BY customer_id
),
rfm_scoring AS (
    SELECT 
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_aggregates
)
SELECT 
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_cell,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS customer_segment
FROM rfm_scoring;


-- Monthly Cohort Retention Matrix Table
CREATE OR REPLACE TABLE gold_cohort_retention AS
WITH customer_first_order AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM silver_orders
    GROUP BY customer_id
),
customer_activities AS (
    SELECT 
        o.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', o.order_date) AS activity_month,
        MONTHS_BETWEEN(DATE_TRUNC('month', o.order_date), c.cohort_month) AS month_number
    FROM silver_orders o
    JOIN customer_first_order c ON o.customer_id = c.customer_id
)
SELECT 
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_id) AS active_customers
FROM customer_activities
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;

