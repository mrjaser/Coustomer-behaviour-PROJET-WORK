SELECT * FROM demo;

1
SELECT
    gender,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping_behavior_cleaned
GROUP BY gender;

2
SELECT
    customer_id,
    age,
    gender,
    item_purchased,
    purchase_amount,
    discount_applied
FROM customer_shopping_behavior_cleaned
WHERE discount_applied = 'Yes'
AND purchase_amount > (
    SELECT AVG(purchase_amount)
    FROM customer_shopping_behavior_cleaned
);

3
SELECT
    item_purchased,
    ROUND(AVG(review_rating), 2) AS average_rating
FROM customer_shopping_behavior_cleaned
GROUP BY item_purchased
ORDER BY average_rating DESC
LIMIT 5;

4
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount), 2) AS average_purchase_amount
FROM customer_shopping_behavior_cleaned
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

PRAGMA table_info(customer_shopping_behavior_cleaned);

5
SELECT 
    subscription_sta,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping_behavior_cleaned
GROUP BY subscription_sta
ORDER BY total_revenue DESC;

6
SELECT 
    item_purchased,
    COUNT(*) as total_purchases,
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) as discount_count,
    ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_percentage
FROM customer_shopping_behavior_cleaned
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

7
SELECT 
    CASE 
        WHEN previous_purchas = 0 THEN 'New'
        WHEN previous_purchas BETWEEN 1 AND 10 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customer_shopping_behavior_cleaned
GROUP BY customer_segment;

8
WITH RankedProducts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(*) AS purchase_count,
        ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(*) DESC) AS rank
    FROM customer_shopping_behavior_cleaned
    GROUP BY category, item_purchased
)
SELECT category, item_purchased, purchase_count
FROM RankedProducts
WHERE rank <= 3;

9
SELECT 
    CASE WHEN previous_purchas > 5 THEN 'Repeat Buyer (>5)' ELSE 'Regular Buyer (<=5)' END AS buyer_type,
    subscription_sta,
    COUNT(*) AS count
FROM customer_shopping_behavior_cleaned
GROUP BY buyer_type, subscription_sta;

10
SELECT 
    CASE 
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(100.0 * SUM(purchase_amount) / (SELECT SUM(purchase_amount) FROM customer_shopping_behavior_cleaned), 2) AS revenue_percentage
FROM customer_shopping_behavior_cleaned
GROUP BY age_group
ORDER BY total_revenue DESC;