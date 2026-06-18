-- ************************************************************* 
-- BUSINESS QUESTION:
-- Which product price range generates the highest total freight
-- cost, and does freight cost per item scale with product price?
-- ************************************************************* 

SELECT
  CASE
    WHEN price <= 100 THEN '0-100'
    WHEN price <= 500 THEN '101-500'
    WHEN price <= 1000 THEN '501-1000'
    ELSE 'Above 1000'
  END AS price_range,
  COUNT(order_id) AS order_count,
  SUM(freight_value) AS total_freight
FROM olist_order_items_dataset
GROUP BY price_range
ORDER BY total_freight DESC;

-- Result:
-- price_range   order_count   total_freight   avg_freight_per_item
-- 0-100         72,337        1,170,911.22    16.2
-- 101-500       37,097          928,102.85    25.0
-- 501-1000       2,372          102,130.07    43.1
-- Above 1000       844           50,765.40    60.2

-- Total orders across all ranges = 112,650
-- 0-100 + 101-500 = 109,434 orders = 97.1% of all order items

-- ************************************************************* 
-- INTERPRETATION:
-- I observe that 97.1% of order items fall in the 0-500 price
-- range, and that average freight cost per item rises steadily
-- with price tier — from 16.2 in the cheapest tier to 60.2 in
-- the most expensive tier. 
-- 
-- This matters because the business's
-- total freight expense is driven by transaction volume in low
-- price tiers rather than by per-unit shipping cost, while
-- premium tier shipments are individually more expensive to
-- fulfill but contribute far less to total freight volume. 
--
-- The business should target the 37,097 buyers currently in the
-- 101-500 tier with upsell campaigns toward the 501-1000 tier,
-- since this is a more realistic upgrade path than moving
-- 0-100 buyers directly to premium tiers. A 30% conversion of
-- 501-1000 tier buyers would add approximately 700 orders to
-- that tier; the exact revenue impact requires average price
-- per tier, which is a data point to calculate in a follow-up
-- query before finalizing investment in this initiative.
-- ************************************************************* 
