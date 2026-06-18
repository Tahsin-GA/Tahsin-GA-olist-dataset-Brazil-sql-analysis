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
-- I observe that while 91.9% of orders are technically delivered early,
-- the estimated delivery date is padded by an average of 11 days beyond
-- actual delivery time (12.1 days, see Q4) — the business quotes ~23 days
-- but typically delivers in 12.
--
-- This matters because the 91.9% figure does not reflect genuine logistics
-- performance. It masks the business's true delivery capability and would
-- prevent honest identification of underperforming regions (see Q5).
--
-- The business should reduce estimate padding from 11 days to a 2-3 day
-- buffer, setting customer-facing estimates at 14-15 days instead of 23 —
-- preserving safety margin for slower regions like Salvador and Belem.
-- ************************************************************* 
