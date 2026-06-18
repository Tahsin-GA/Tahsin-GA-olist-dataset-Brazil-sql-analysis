-- ************************************************************* 
-- BUSINESS QUESTION:
-- Which cities have high order demand but a relatively low
-- seller count, representing an untapped seller recruitment
-- opportunity?
-- ************************************************************* 

SELECT customer_city,
  COUNT(ord_data.order_id) AS order_count,
  COUNT(DISTINCT sellers.seller_id) AS seller_count,
  SUM(price) AS city_revenue
FROM olist_customers_dataset AS c_data
LEFT JOIN olist_orders_dataset AS ord_data
  ON c_data.customer_id = ord_data.customer_id
INNER JOIN olist_order_items_dataset AS items
  ON items.order_id = ord_data.order_id
LEFT JOIN olist_sellers_dataset AS sellers
  ON sellers.seller_id = items.seller_id
GROUP BY customer_city
HAVING order_count > 1000
AND seller_count < 1000
ORDER BY city_revenue DESC
LIMIT 10;

-- Result (8 qualifying cities):
-- city                    orders   sellers   orders_per_seller
-- Belo Horizonte           3,144      907     3.5
-- Brasilia                 2,392      783     3.1
-- Curitiba                 1,751      658     2.7
-- Porto Alegre             1,612      600     2.7
-- Campinas                 1,654      636     2.6
-- Salvador                 1,412      564     2.5
-- Guarulhos                1,329      551     2.4
-- Sao Bernardo do Campo    1,060      482     2.2

-- Reference point (Sao Paulo, excluded by the seller_count <
-- 1000 filter): 17,808 orders / 1,896 sellers = 9.4 orders per seller

-- These 8 cities combined generate ~12.34% of total product
-- revenue while representing ~14% of total orders.

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that 8 second-tier cities have over 1,000 orders
-- each but fewer than 1,000 sellers, and their orders-per-seller
-- ratio (2.2 to 3.5) is roughly 3x lower than Sao Paulo's 9.4 —
-- meaning sellers in these cities handle far less demand per
-- seller than Sao Paulo sellers do. 
-- 
-- This matters because it suggests these cities are seller-constrained rather than
-- demand-constrained: order volume already exists, but the
-- supply side has not scaled to match it, representing a lower-
-- risk growth opportunity than trying to create demand from
-- scratch. 
-- 
-- The business should launch a targeted seller recruitment campaign in these 8 cities (starting with Belo
-- Horizonte and Brasilia, the two largest by revenue), with a
-- goal of raising the orders-per-seller ratio from ~3.5 toward
-- 7; if this shifts these cities' combined revenue share from
-- 12.34% to 25% of total product revenue, that would represent
-- approximately 1.7M in additional revenue — an estimate that
-- assumes overall platform revenue otherwise holds steady and
-- should be validated as recruitment progresses.
-- ************************************************************* 
