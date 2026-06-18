-- ************************************************************* 
-- BUSINESS QUESTION:
-- What is the average number of days between order approval
-- and the order reaching the customer?
-- ************************************************************* 

SELECT ROUND(AVG(
  julianday(order_delivered_customer_date) - julianday(order_approved_at)
), 1) AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

-- Result: 12.1 days average delivery time (approval to customer)

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that the average delivery time from order approval
-- to customer receipt is 12.1 days. 
-- 
-- This matters for two reasons: customers are more likely to cancel or churn the
-- longer they wait, and sellers experience delayed cash flow
-- since payment settlement is tied to delivery confirmation —
-- a seller waiting 12 days for settlement has materially worse
-- liquidity than one settling in 5-7 days. No industry benchmark
-- for Brazilian e-commerce delivery speed exists within this
-- dataset, so this number cannot yet be judged as strong or
-- weak in isolation — it requires external benchmarking. 
-- 
-- The business should treat 12.1 days as the baseline against which
-- all city-level and seller-level delivery performance is
-- measured (see Q5), and pursue last-mile logistics partnerships
-- in any region performing meaningfully above this baseline.
-- ************************************************************* 
