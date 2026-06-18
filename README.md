# Olist E-Commerce SQL Analysis

## Project Overview
This project answers 10 real business questions using SQL — from revenue concentration to delivery performance to sellerdistribution. Each query is paired with a business interpretation following a structured framework: what the data shows, why it matters, and what action it recommends. The project demonstrates SQL proficiency alongside business reasoning and data-driven decision making.

## Dataset
Olist Brazilian E-Commerce — 5 tables:
customers, orders, payments, order items, sellers

## Skills Demonstrated
SQL — JOINs, subqueries, CASE WHEN, 
date functions, dynamic filters, 
aggregations, percentage calculations

## Dataset File: 
Olist Brazilian E-Commerce Public Dataset
## Tables used: 
olist_customers_dataset, olist_orders_dataset,
olist_order_payments_dataset, olist_order_items_dataset,
olist_sellers_dataset

## Questions

## File
- Q1_payment_segmentation.sql : What share of orders are High/Medium/Low value, and what does that mean for revenue concentration?
- Q2_top_cities_revenue.sql : Which cities drive the most revenue, and how concentrated is that revenue geographically?
- Q3_freight_by_price_range.sql :  How does freight cost scale across product price tiers?
- Q4_avg_delivery_time.sqlWhat is the average delivery time from order approval to customer receipt?
- Q5_delayed_cities_threshold.sqlWhich cities have genuinely above-average delivery times once statistical noise is removed?
- Q6_estimated_vs_actual_delivery.sqlIs the 91.9% "early delivery" rate real performance or an artifact of padded estimates?
- Q7_seller_concentration.sqlWhat share of revenue comes from the top 10 sellers?
- Q8_installment_behavior.sqlHow does installment usage differ by city and payment method?
- Q9_monthly_revenue_by_payment.sqlIs any payment method gaining share of monthly revenue over time?
- Q10_underserved_cities.sqlWhich cities have high order demand but a low seller count?


## Key findings at a glance

- 4.1% of orders are high-value (>500), but this segment is the most
vulnerable to cancellation
- Top 5 cities generate 27.4% of total revenue; Top 100 generate 60.7%
- Average delivery time is 12.1 days, but estimated delivery dates are
padded by an average of 11 days, making the 91.9% "early" rate misleading
- Northeast cities (Salvador, Belem, Fortaleza) show delivery times 57-73%
above the national average — concentrated in one geographic region
- Top 10 sellers (0.32% of all sellers) generate 13.15% of revenue —
healthier distribution than typical concentrated marketplaces
- Debit card payment share grew 9x (0.5% → 4.5%) over 20 months while
credit card share stayed stable at 75-80%
- 8 cities show strong order demand but low seller density, representing a
lower-risk seller recruitment opportunity than demand generation

## Tools
DB Browser for SQLite

