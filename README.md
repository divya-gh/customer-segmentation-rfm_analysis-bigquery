# customer-segmentation-rfm_analysis-bigquery
RFM analysis to help the marketing team identify customer behavior and focus their marketing efforts to keep customers engaged. Customer segmentation using recency, frequency, and monetary value by ranking customers in four groups including High-Value Customers, Loyal Customers, At Risk Customers, and Persuadable Customers.. 

# Customer Segmentation using RFM Analysis in BigQuery

## 📌 Project Overview
This project focuses on analyzing customer behavior for **TheLook eCommerce**, a retail dataset. Using **Google BigQuery** and **Standard SQL**, I implemented an **RFM (Recency, Frequency, Monetary)** analysis to segment the customer base.

The goal was to address declining customer retention by categorizing users into actionable segments (e.g., *High Value*, *Loyal*, *At Risk*, *Persuadable*) to enable targeted marketing strategies.

## 🛠️ Technologies & Concepts Used
* **Platform:** Google Cloud Platform (BigQuery)
* **Language:** SQL (Standard Dialect)
* **Key Concepts:**
    * **Data Transformation:** `INNER JOIN`, Grouping, and Aggregation.
    * **Date Functions:** `DATE_DIFF`, `CURRENT_TIMESTAMP`.
    * **Window Functions:** `NTILE()` for statistical quantile calculation.
    * **CTEs (Common Table Expressions):** For modular, readable code.
    * **Conditional Logic:** `CASE` statements for segment labeling.

## 💼 Business Scenario
TheLook eCommerce has seen rapid growth but is struggling with retention. The marketing team needed a data-driven approach to identify:
1.  **Recency:** How long since the customer's last purchase?
2.  **Frequency:** How often does the customer buy?
3.  **Monetary Value:** How much does the customer spend?

Customer segmentation to help marketing team target ad on customer behaviour
1. **High-Value Customers** - High Monetory Vaue & High frequency
2. **Loyal Customers** - High frequency
3. **At Risk Customers** - low recency
4. **Persuadable Customers** - High recency

## 📊 Methodology

### Step 1: Data Exploration
I began by analyzing the `orders` and `order_items` tables within the `thelook_ecommerce` public dataset to understand the schema and relationships between `user_id`, `order_id`, and `sale_price`.

### Step 2: Calculating RFM Metrics
I constructed queries to calculate the individual components of RFM:
* **Recency:** Calculated the difference in days between the current date and the maximum `created_at` timestamp for each user.
* **Frequency:** Counted the total unique `order_id`s per user.
* **Monetary:** Summed the `sale_price` from the `order_items` table joined with `orders`.

### Step 3: Statistical Segmentation (The "Secret Sauce")
Instead of using arbitrary hard-coded thresholds (e.g., "spent more than $100"), I used the `NTILE(4)` window function. This divides the customer base into **quartiles (1-4)** for each metric, ensuring the segmentation scales dynamically as the data changes.

* **Quartile 4:** Best performance (Most recent, most frequent, highest spend).
* **Quartile 1:** Lowest performance.

### Step 4: Final CTE & Logic
I utilized Common Table Expressions (CTEs) to stage the data and applied the following logic to label the customers:

| Segment | Logic Used |
| :--- | :--- |
| **High Value Customer** | Top tier Spend (3-4) AND Top tier Frequency (3-4) |
| **Loyal Customer** | Top tier Frequency (3-4) |
| **Persuadable Customer** | Top tier Recency (3-4) (Recently active but maybe low spend) |
| **At Risk Customer** | Bottom tier Recency (1) (Hasn't bought in a long time) |

## 📝 The SQL Query
Below is the consolidated SQL query used to generate the final segmentation report:

```sql
WITH rfm_calc AS (
    SELECT
        o.user_id AS customer_id,
        DATE_DIFF(CURRENT_TIMESTAMP(), MAX(o.created_at), DAY) AS recency,
        COUNT(o.order_id) AS frequency,
        ROUND(SUM(oi.sale_price)) AS monetary
    FROM
        `thelook_ecommerce.orders` o
    INNER JOIN
        `thelook_ecommerce.order_items` oi
    ON
        o.order_id = oi.order_id
    GROUP BY
        customer_id
),
rfm_quant AS (
    SELECT
        customer_id,
        NTILE(4) OVER (ORDER BY recency) AS recency_quantile,
        NTILE(4) OVER (ORDER BY frequency) AS frequency_quantile,
        NTILE(4) OVER (ORDER BY monetary) AS monetary_quantile
    FROM
        rfm_calc
)
SELECT
    customer_id,
    recency_quantile,
    frequency_quantile,
    monetary_quantile,
    CASE
        WHEN monetary_quantile >= 3 AND frequency_quantile >= 3 THEN "High Value Customer"
        WHEN frequency_quantile >= 3 THEN "Loyal Customer"
        WHEN recency_quantile <= 1 THEN "At Risk Customer"
        WHEN recency_quantile >= 3 THEN "Persuadable Customer"
        ELSE "General"
    END AS customer_segment
FROM
    rfm_quant;


```
## 🚀 Results & Impact
By running this analysis, we successfully transformed raw transaction logs into a strategic asset. The marketing team can now:
. Send "We Miss You" coupons specifically to the At Risk group.
. Offer VIP Early Access to High Value Customers.
. Target Persuadable Customers with Upsell offers to increase their basket size.

## 📚 Acknowledgements
. Dataset provided by Google Cloud Public Datasets.
. Project inspired by the "Apply RFM method to segment customer data" lab on Google Cloud Skills Boost.