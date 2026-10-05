
-- ============================================================
-- Elevate Labs - Task 3: SQL for Data Analysis
-- Database: Ecommerce_SQL_Database
-- ============================================================


-- 1. SELECT
SELECT
    customer_id,
    customer_name,
    city
FROM customers;


-- 2. WHERE
SELECT
    customer_id,
    customer_name,
    city
FROM customers
WHERE city = 'Bangalore';


-- 3. ORDER BY
SELECT
    product_name,
    category,
    price
FROM products
ORDER BY price DESC;


-- 4. GROUP BY with SUM
SELECT
    category,
    SUM(price) AS total_product_value
FROM products
GROUP BY category
ORDER BY total_product_value DESC;


-- 5. GROUP BY with AVG
SELECT
    category,
    AVG(price) AS average_price
FROM products
GROUP BY category
ORDER BY average_price DESC;


-- 6. Total Revenue
SELECT
    SUM(quantity * unit_price) AS total_revenue
FROM order_items;


-- 7. Top-Selling Products
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- 8. Revenue by Category
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- 9. Average Order Value
SELECT
    AVG(total_amount) AS average_order_value
FROM orders;


-- 10. Top Customers by Number of Orders
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 10;


-- 11. Top Customers by Total Spending
SELECT
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;


-- 12. Highest-Value Orders
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM orders
ORDER BY total_amount DESC
LIMIT 10;


-- 13. Subquery - Customers Spending Above Average
SELECT
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    )
)
ORDER BY total_spent DESC;


-- 14. INNER JOIN
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY o.total_amount DESC;


-- 15. LEFT JOIN
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.total_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


-- 16. RIGHT JOIN
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.order_date,
    o.total_amount
FROM orders o
RIGHT JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY c.customer_id;


-- 17. CREATE VIEW
CREATE VIEW customer_spending AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;


-- 18. Use the View
SELECT *
FROM customer_spending
ORDER BY total_spent DESC;


-- 19. Create Index
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);


-- 20. Query Optimization
EXPLAIN QUERY PLAN
SELECT
    c.customer_name,
    o.order_id,
    o.total_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.customer_id = 1;
