-- ************************************************************* 
-- BUSINESS QUESTION:
-- What percentage of orders fall into High, Medium, and Low
-- payment value categories, and what does this distribution
-- mean for revenue concentration and growth strategy?
-- ************************************************************* 

-- Step 1: Categorize every order into a payment tier and count
-- how many orders fall into each tier.

SELECT
  CASE
    WHEN payment_value < 100 THEN 'Low'
    WHEN payment_value BETWEEN 100 AND 500 THEN 'Medium'
    WHEN payment_value > 500 THEN 'High'
  END AS payment_category,
  COUNT(order_id) AS order_count
FROM olist_order_payments_dataset
GROUP BY payment_category
ORDER BY order_count DESC;

-- Result:
-- Low      51,855 orders   (49.9%)
-- Medium   47,775 orders   (46.0%)
-- High      4,256 orders   ( 4.1%)

-- Step 2: Quantify how many orders qualify as "high value"
-- (above 1,000) to size the premium segment precisely.

SELECT COUNT(payment_value)
FROM olist_order_payments_dataset
WHERE payment_value >= 1000;

-- Result: 1,150 orders generate payment values above 1,000
-- That is 1.16% of total orders.

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that only 4.1% of orders (4,256 out of 103,886) are
-- classified as high value, and just 1.16% (1,150 orders) exceed
-- 1,000 in payment value. This matters because the business's
-- revenue is structurally dependent on high-volume, low-margin
-- transactions, which limits pricing power and makes total
-- revenue highly sensitive to order volume rather than order
-- value. The business should identify which product categories
-- generate the 1,150 high-value orders and direct marketing
-- spend toward those categories, targeting growth from 1,150 to
-- 2,300 high-value orders within one quarter — a realistic
-- doubling that would materially shift revenue mix toward higher
-- margin transactions.
-- ************************************************************* 
