-- Determine the total amount spent in 2022
-- Monetary value is the total amount of money a customer has spent with a company over a specified period of time.
-- Identifying customers with the highest monetary value can help businesses improve customer relationships and target their marketing efforts to their most profitable customers.
SELECT
  o.user_id AS customer_id,
  SUM(oi.sale_price) as monetary
FROM `thelook_ecommerce.orders` o
INNER JOIN `thelook_ecommerce.order_items` oi
ON o.order_id = oi.order_id
WHERE o.created_at >= '2022-01-01' and o.created_at < '2023-01-01'
GROUP BY customer_id
LIMIT 10;     