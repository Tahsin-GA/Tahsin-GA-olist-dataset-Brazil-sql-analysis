-- ************************************************************* 
-- BUSINESS QUESTION:
-- Is the business's 91.9% "early delivery" rate genuine
-- operational performance, or is it manufactured by overly
-- conservative delivery estimates?
-- ************************************************************* 

-- Step 1: Categorize every delivered order as Early, On Time,
-- or Late relative to its estimated delivery date.

SELECT
  CASE
    WHEN julianday(order_delivered_customer_date) - julianday(order_estimated_delivery_date) < 0 THEN 'Early'
    WHEN julianday(order_delivered_customer_date) - julianday(order_estimated_delivery_date) = 0 THEN 'On Time'
    WHEN julianday(order_delivered_customer_date) - julianday(order_estimated_delivery_date) > 0 THEN 'Late'
  END AS delivery_quality,
  COUNT(order_delivered_customer_date) AS order_count
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_quality;

-- Result:
-- Early     88,649 orders   (91.9%)
-- Late       7,827 orders   ( 8.1%)
-- On Time        0 orders   (exact date match is essentially never observed)

-- Step 2: Calculate the average gap between the estimated
-- delivery date and the actual delivery date to test whether
-- the "early" rate is driven by estimate padding.

SELECT ROUND(AVG(
  julianday(order_estimated_delivery_date) - julianday(order_delivered_customer_date)
), 0) AS avg_estimate_padding_days
FROM olist_orders_dataset;

-- Result: 11 days average padding between estimated and actual delivery

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that while 91.9% of orders are technically delivered
-- "early," the average estimated delivery date is set 11 days
-- later than the actual average delivery time of 12.1 days
-- (see Q4) — meaning the business is quoting roughly 23 days
-- when it typically delivers in 12. 
-- This matters because the 91.9% early-delivery figure is not a genuine reflection of
-- logistics performance; it is a byproduct of conservative
-- estimate-setting, and presenting it as a performance metric
-- internally would mask the business's true delivery capability
-- and prevent honest identification of regions that are actually
-- underperforming (see Q5). 
-- The business should reduce estimate padding from 11 days to a 2-3 day buffer above the actual
-- average, setting customer-facing estimates around 14-15 days
-- instead of 23 — this would create an honest performance
-- baseline while still preserving a safety margin for delayed
-- regions like Salvador and Belem.
-- =============================================================
