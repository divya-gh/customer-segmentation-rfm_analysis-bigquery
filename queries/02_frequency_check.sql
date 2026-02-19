-- Determine the order frequency in 2022
-- Customers who place orders more frequently are considered to be more engaged with the brand and are more likely to make repeat purchases in the future.

select 
    customer_id,
    count(order_id) as frequency
FROM `thelook_ecommerce.orders`
WHERE created_at >= '2022-01-01' and created_at < '2023-01-01'
GROUP BY customer_id
ORDER BY frequency DESC
LIMIT 10;