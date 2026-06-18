-- ************************************************************* 
-- BUSINESS QUESTION:
-- Which cities generate the most payment value, and what
-- percentage of total revenue do the top cities represent?
-- ************************************************************* 

-- Step 1: Rank top 100 cities by total payment value.

SELECT customer_city, SUM(payment_value) AS city_revenue
FROM olist_customers_dataset AS c_data
INNER JOIN olist_orders_dataset AS ord_data
  ON c_data.customer_id = ord_data.customer_id
LEFT JOIN olist_order_payments_dataset AS pay_data
  ON pay_data.order_id = ord_data.order_id
GROUP BY c_data.customer_city
ORDER BY city_revenue DESC
LIMIT 100;

-- Step 2: Sum the revenue of the top 100 cities to compare
-- against total dataset revenue.

SELECT SUM(city_revenue) FROM (
  SELECT customer_city, SUM(payment_value) AS city_revenue
  FROM olist_customers_dataset AS c_data
  INNER JOIN olist_orders_dataset AS ord_data
    ON c_data.customer_id = ord_data.customer_id
  LEFT JOIN olist_order_payments_dataset AS pay_data
    ON pay_data.order_id = ord_data.order_id
  GROUP BY c_data.customer_city
  ORDER BY city_revenue DESC
  LIMIT 100
);
-- Result: 9,725,306

-- Step 3: Get total payment revenue across the entire dataset
-- to calculate concentration percentage.

SELECT SUM(payment_value) FROM olist_order_payments_dataset;
-- Result: 16,008,872

-- Top 100 cities = 9,725,306 / 16,008,872 = 60.7% of total revenue
-- Top 5 cities   = 4,388,674 / 16,008,872 = 27.4% of total revenue

-- Step 4: Compare order volume to AOV for the top 2 cities to
-- understand WHY Sao Paulo leads revenue (volume vs. price).

-- Sao Paulo:      15,540 orders | AOV ~141  (2nd lowest AOV in top cities)
-- Rio de Janeiro:  6,882 orders | AOV ~169

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that just 5 cities (2.4% of 4,119 total cities)
-- generate 27.4% of total revenue, and the top 100 cities
-- generate 60.7%. This matters because Sao Paulo, the single
-- largest revenue source, achieves this through order volume
-- rather than order value — its AOV of 141 is the second-lowest
-- among top cities, well below the national average of 154.
-- This reveals two distinct growth levers: volume-driven cities
-- like Sao Paulo and value-driven cities like Salvador (AOV 175).
-- The business should run premium product promotions targeted
-- at existing Sao Paulo customers to lift AOV from 141 toward
-- the national average of 154, which would generate approximately
-- 202,000 in additional revenue (13 AOV gap x 15,540 orders)
-- without requiring any increase in order volume.
-- ************************************************************* 
