-- ************************************************************* 
-- BUSINESS QUESTION:
-- How stable is credit card's dominance of monthly revenue over
-- time, and is any alternative payment method gaining share?
-- ************************************************************* 

SELECT
  monthly_by_type.month,
  payment_type,
  ROUND(type_revenue / total_revenue * 100, 1) AS percentage
FROM (
  SELECT
    strftime('%Y-%m', ord.order_purchase_timestamp) AS month,
    pay.payment_type,
    SUM(pay.payment_value) AS type_revenue
  FROM olist_order_payments_dataset AS pay
  LEFT JOIN olist_orders_dataset AS ord ON pay.order_id = ord.order_id
  WHERE ord.order_purchase_timestamp IS NOT NULL
  GROUP BY month, pay.payment_type
) AS monthly_by_type
LEFT JOIN (
  SELECT
    strftime('%Y-%m', ord.order_purchase_timestamp) AS month,
    SUM(pay.payment_value) AS total_revenue
  FROM olist_order_payments_dataset AS pay
  LEFT JOIN olist_orders_dataset AS ord ON pay.order_id = ord.order_id
  WHERE ord.order_purchase_timestamp IS NOT NULL
  GROUP BY month
) AS monthly_total
ON monthly_by_type.month = monthly_total.month
ORDER BY monthly_by_type.month, payment_type;

-- Result pattern (Jan 2017 - Aug 2018, clean date range):
-- credit_card   -> stable 75-80% of monthly revenue throughout
--                  (Jan 2017: 79.2%  |  Aug 2018: 78.0%)
-- boleto        -> stable 15-21% range
-- voucher       -> stable 2-3% range
-- debit_card    -> grew from 0.5% (Jan 2017) to 4.5% (Aug 2018) = 9x growth

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that credit card's share of monthly revenue is
-- structurally stable, moving only from 79.2% to 78.0% across
-- 20 months, while debit card share grew nearly 9x in the same
-- period, from 0.5% to 4.5%. 
--
-- This matters because it signals an emerging customer segment adopting debit card payment — likely
-- a different demographic than the dominant credit card base,
-- since debit card does not offer installment flexibility (see Q8) 
-- and therefore attracts a different type of buyer. 
--
-- The business should investigate which cities, product categories,
-- and price tiers are driving debit card growth and build
-- targeted campaigns for this segment rather than treating all
-- customers as credit-card-first; if the current growth rate
-- continues at even half its current trajectory, debit card
-- could represent 8-10% of transactions by the end of 2019,
-- representing meaningful incremental revenue without
-- cannibalizing the existing credit card base.
-- ************************************************************* 
