-- Find the 10 most recent orders . 
-- Recency refers to how recently a customer made a purchase. It is measured in units of time, such as days, weeks, or months. A higher recency score indicates that a customer has made a purchase more recently.

SELECT
user_id AS customer_id,
DATE_DIFF(CURRENT_TIMESTAMP(), MAX(created_at), DAY) AS recency,
FROM `thelook_ecommerce.orders`
GROUP BY
user_id
ORDER BY recency DESC
LIMIT 10;