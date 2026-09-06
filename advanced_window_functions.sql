-- =====================================================
-- WINDOW FUNCTIONS — OLIST DATASET
-- =====================================================
-- Window Functions perform calculations across rows
-- WITHOUT collapsing them (unlike GROUP BY)
-- Key syntax: FUNCTION() OVER (ORDER BY column)
-- OVER() is what makes any function a Window Function
-- =====================================================

-- 1. RANK() — Rank sellers by revenue
-- RANK allows ties and skips numbers after a tie
-- Wrapped in subquery to filter top 10 by rank
-- Advantage over LIMIT: rank is visible as a column
-- and filter threshold can be changed without rewriting
SELECT * FROM (
    SELECT
        seller_id,
        SUM(price) AS seller_revenue,
        RANK() OVER (ORDER BY SUM(price) DESC) AS revenue_rank
    FROM olist_order_items_dataset
    GROUP BY seller_id
    ORDER BY revenue_rank
) WHERE revenue_rank <= 10;

-- 2. RANK() vs ROW_NUMBER() comparison
-- RANK: allows ties, skips rank numbers after a tie
-- ROW_NUMBER: no ties, always unique, never skips
-- Difference only visible when two rows have identical values
-- In this dataset all seller revenues are unique
-- so both columns show identical results
SELECT
    seller_id,
    SUM(price) AS seller_revenue,
    RANK() OVER (ORDER BY SUM(price) DESC) AS rank_number,
    ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) AS row_number
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY seller_revenue DESC
LIMIT 20;

-- 3. LAG() — Month-over-month revenue comparison (full dataset)
-- LAG fetches the previous row value as a new column
-- First row always shows blank — no previous month exists
-- Eliminates need for a separate subquery to get last month
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS order_month,
    SUM(payment_value) AS monthly_revenue,
    LAG(SUM(payment_value)) OVER (
        ORDER BY strftime('%Y-%m', order_purchase_timestamp)
    ) AS previous_month_revenue
FROM olist_orders_dataset
JOIN olist_order_payments_dataset
    ON olist_orders_dataset.order_id =
       olist_order_payments_dataset.order_id
GROUP BY order_month
ORDER BY order_month;

-- 4. LAG() — Filtered to 2017 only (independent practice query)
-- HAVING used instead of WHERE because order_month is
-- an alias created in SELECT — not available in WHERE clause
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS order_month,
    SUM(payment_value) AS monthly_revenue,
    LAG(SUM(payment_value)) OVER (
        ORDER BY strftime('%Y-%m', order_purchase_timestamp)
    ) AS previous_month_revenue
FROM olist_orders_dataset
JOIN olist_order_payments_dataset
    ON olist_orders_dataset.order_id =
       olist_order_payments_dataset.order_id
GROUP BY order_month
HAVING order_month LIKE '2017-%'
ORDER BY order_month;

-- 5. LEAD() — Next month revenue lookup (opposite of LAG)
-- LEAD fetches the NEXT row value instead of previous
-- Last row always shows blank — no next month exists
-- Use case: forecasting, next-period comparison,
-- churn detection (did customer return next month?)
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS order_month,
    SUM(payment_value) AS monthly_revenue,
    LEAD(SUM(payment_value)) OVER (
        ORDER BY strftime('%Y-%m', order_purchase_timestamp)
    ) AS next_month_revenue
FROM olist_orders_dataset
JOIN olist_order_payments_dataset
    ON olist_orders_dataset.order_id =
       olist_order_payments_dataset.order_id
GROUP BY order_month
HAVING order_month LIKE '2017-%'
ORDER BY order_month;