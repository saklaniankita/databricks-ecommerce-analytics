-- Create database/schema for the analytics project
CREATE SCHEMA IF NOT EXISTS ecommerce_lakehouse;
USE ecommerce_lakehouse;

-- Bronze Table 1: Raw Customers
CREATE TABLE IF NOT EXISTS bronze_customers (
    customer_id STRING,
    signup_date STRING,
    country STRING
) USING DELTA;

-- Bronze Table 2: Raw Products
CREATE TABLE IF NOT EXISTS bronze_products (
    product_id STRING,
    category STRING,
    price STRING
) USING DELTA;

-- Bronze Table 3: Raw Orders
CREATE TABLE IF NOT EXISTS bronze_orders (
    order_id STRING,
    customer_id STRING,
    product_id STRING,
    order_date STRING,
    total_amount STRING,
    status STRING
) USING DELTA;

USE ecommerce_lakehouse;

-- Insert Customers Data
INSERT INTO bronze_customers VALUES
('C101', '2024-01-10', 'USA'),
('C102', '2024-01-15', 'UK'),
('C103', '2024-02-01', 'USA'),
('C104', '2024-02-12', 'Canada'),
('C105', '2024-03-05', 'USA');

-- Insert Products Data
INSERT INTO bronze_products VALUES
('P01', 'Electronics', '120.00'),
('P02', 'Apparel', '45.00'),
('P03', 'Home', '85.00');

-- Insert Orders Data
INSERT INTO bronze_orders VALUES
('O501', 'C101', 'P01', '2024-01-12', '120.00', 'Completed'),
('O502', 'C102', 'P02', '2024-01-18', '45.00', 'Completed'),
('O503', 'C101', 'P03', '2024-02-14', '85.00', 'Completed'),
('O504', 'C103', 'P01', '2024-02-20', '120.00', 'Completed'),
('O505', 'C102', 'P02', '2024-02-25', '45.00', 'Completed'),
('O506', 'C104', 'P03', '2024-02-28', '85.00', 'Completed'),
('O507', 'C101', 'P02', '2024-03-10', '45.00', 'Completed'),
('O508', 'C105', 'P01', '2024-03-12', '120.00', 'Completed'),
('O509', 'C103', 'P03', '2024-03-15', '85.00', 'Completed'),
('O510', 'C102', 'P02', '2024-03-18', '45.00', 'Cancelled');

select * from bronze_orders;