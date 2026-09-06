-- =====================================================
-- CTEs (Common Table Expressions) — OLIST DATASET
-- =====================================================
-- CTE = Common Table Expression
-- Common: can be referenced multiple times in one query
-- Table: behaves like a temporary table
-- Expression: disappears after query finishes
--
-- WHY USE CTEs INSTEAD OF NESTED SUBQUERIES:
-- Readable — logic flows top to bottom like steps
-- Testable — each CTE block can be run independently
-- Maintainable — easier to debug and modify
--
-- This query rewrites Question 9 (monthly payment type
-- percentage share) using CTEs instead of nested subqueries
-- The logic and output are identical — only readability differs
-- =====================================================

-- STEP 1: Revenue per payment type per month
WITH monthly_by_type AS (
    SELECT
        strftime('%Y-%m', ord.order_purchase_timestamp) AS month,
        pay.payment_type,
        SUM(pay.payment_value) AS type_revenue
    FROM olist_order_payments_dataset AS pay
    LEFT JOIN olist_orders_dataset AS ord
        ON pay.order_id = ord.order_id
    WHERE ord.order_purchase_timestamp IS NOT NULL
    GROUP BY month, pay.payment_type
),

-- STEP 2: Total revenue per month (all payment types combined)
monthly_total AS (
    SELECT
        strftime('%Y-%m', ord.order_purchase_timestamp) AS month,
        SUM(pay.payment_value) AS total_revenue
    FROM olist_order_payments_dataset AS pay
    LEFT JOIN olist_orders_dataset AS ord
        ON pay.order_id = ord.order_id
    WHERE ord.order_purchase_timestamp IS NOT NULL
    GROUP BY month
)

-- STEP 3: Join both CTEs and calculate percentage share
-- type_revenue / total_revenue gives decimal — multiply by 100
-- ROUND to 1 decimal place for clean presentation
SELECT
    monthly_by_type.month,
    payment_type,
    ROUND(type_revenue / total_revenue * 100, 1) AS percentage
FROM monthly_by_type
LEFT JOIN monthly_total
    ON monthly_by_type.month = monthly_total.month
ORDER BY monthly_by_type.month, payment_type;