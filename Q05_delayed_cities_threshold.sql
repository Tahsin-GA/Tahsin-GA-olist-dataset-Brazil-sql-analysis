-- ************************************************************* 
-- BUSINESS QUESTION:
-- Which cities consistently experience delivery times above
-- the national average (12.1 days), once statistically
-- insignificant cities (very low order counts) are excluded?
-- ************************************************************* 

-- Step 1 (without a minimum order threshold) — this returns
-- noise: cities with 1-2 total orders showing extreme averages
-- like 148 days, which is not a real operational pattern.

SELECT customer_city, ROUND(avg_days, 0), ord_count
FROM (
  SELECT c_data.customer_city,
    AVG(julianday(order_delivered_customer_date) - julianday(order_approved_at)) AS avg_days,
    COUNT(ord_data.order_id) AS ord_count
  FROM olist_orders_dataset AS ord_data
  LEFT JOIN olist_customers_dataset AS c_data
    ON ord_data.customer_id = c_data.customer_id
  WHERE order_delivered_customer_date IS NOT NULL
  GROUP BY c_data.customer_city
)
ORDER BY avg_days DESC
LIMIT 10;

-- Step 2 — apply a minimum order threshold (24, the dataset's
-- average orders-per-city) so only statistically meaningful
-- cities are evaluated, and filter to cities above the national
-- average delivery time.

SELECT customer_city, ROUND(avg_days, 0), ord_count
FROM (
  SELECT c_data.customer_city,
    AVG(julianday(order_delivered_customer_date) - julianday(order_approved_at)) AS avg_days,
    COUNT(ord_data.order_id) AS ord_count
  FROM olist_orders_dataset AS ord_data
  LEFT JOIN olist_customers_dataset AS c_data
    ON ord_data.customer_id = c_data.customer_id
  WHERE order_delivered_customer_date IS NOT NULL
  GROUP BY c_data.customer_city
)
WHERE avg_days > (
  SELECT AVG(julianday(order_delivered_customer_date) - julianday(order_approved_at))
  FROM olist_orders_dataset
  WHERE order_delivered_customer_date IS NOT NULL
)
AND ord_count > 24
ORDER BY avg_days DESC
LIMIT 10;

-- Result (real pattern, not noise):
-- Salvador        19 days   1,188 orders   (57% above national avg)
-- Belem           21 days     431 orders   (73% above national avg)
-- Fortaleza       20 days     618 orders   (65% above national avg)
-- Rio de Janeiro  14 days   6,604 orders   (16% above national avg)

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that once statistical noise is removed (cities with
-- under 24 orders), a clear geographic pattern emerges: Salvador,
-- Belem, and Fortaleza — all in Brazil's North/Northeast regions
-- — show delivery times 57-73% above the 12.1 day national
-- average, while southeast cities like Rio de Janeiro stay much
-- closer to baseline at just 16% above average. 
-- 
-- This matters because the delay is concentrated in a specific geographic
-- region far from the southeast distribution hubs, suggesting
-- the cause is logistics network coverage rather than random
-- operational failure — though without warehouse location data
-- this remains a hypothesis, not a confirmed cause. 
-- 
-- The business should prioritize last-mile delivery partnerships specifically
-- in North and Northeast Brazil, with a target of reducing
-- Belem and Salvador delivery times toward the 12.1 day national
-- average — a 36-43% reduction from current levels.
-- ************************************************************* 
