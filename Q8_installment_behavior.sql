-- =============================================================
-- BUSINESS QUESTION:
-- For the top 10 cities by order count, what is the average
-- number of installments used per payment method, and what
-- does this reveal about regional purchasing behavior?
-- =============================================================

SELECT customer_city, payment_type, AVG(payment_installments) AS avg_installments
FROM olist_customers_dataset AS c_data
LEFT JOIN olist_orders_dataset AS ord_data
  ON c_data.customer_id = ord_data.customer_id
LEFT JOIN olist_order_payments_dataset AS pay_data
  ON ord_data.order_id = pay_data.order_id
WHERE customer_city IN (
  SELECT customer_city
  FROM olist_customers_dataset AS c
  LEFT JOIN olist_orders_dataset AS o ON c.customer_id = o.customer_id
  GROUP BY customer_city
  ORDER BY COUNT(o.order_id) DESC
  LIMIT 10
)
GROUP BY customer_city, payment_type
ORDER BY customer_city, payment_type;

-- Result pattern across all 10 cities:
-- boleto, debit_card, voucher  -> always 1.0 installments (no installment option exists for these methods)
-- credit_card                 -> ranges from 2.98 (Sao Paulo) to 3.74 (Salvador)

-- =============================================================
-- INTERPRETATION:
-- I observe that boleto, debit card, and voucher payments show
-- exactly 1.0 average installments across every city because
-- these payment methods do not support installment plans in
-- Brazil — only credit card does, and its average ranges from
-- 2.98 installments in Sao Paulo to 3.74 in Salvador. This
-- matters because Salvador is a Northeast Brazilian city with
-- generally lower average income than Southeast cities like
-- Sao Paulo, and higher installment usage there likely reflects
-- customers needing to spread payments over more months to
-- afford purchases — this connects directly to Salvador's
-- elevated delivery time finding (Q5), reinforcing that Salvador
-- represents a distinct regional customer profile. The business
-- should pilot extended installment plans (e.g., 6 installments
-- instead of the current typical 3) for high-price products
-- specifically in Northeast cities like Salvador; the precise
-- revenue impact is unknown and should be validated through a
-- 90-day A/B test before wider rollout.
-- =============================================================
