Write an SQL query to get the top three selling products by revenue, using the order_items and products tables.

Get three top selling products by Revenue

Order_Items - (order_id, product_id, quantity)

Products(product_id, price)


-- Step 1: Create tables
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    price DECIMAL(10,2)
);

CREATE TABLE Order_Items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Step 2: Insert sample data
INSERT INTO Products (product_id, price) VALUES
(1, 100.00),
(2, 150.00),
(3, 200.00),
(4, 250.00),
(5, 300.00);

INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(101, 1, 5),
(102, 2, 3),
(103, 3, 4),
(104, 4, 2),
(105, 5, 1),
(106, 2, 2),
(107, 3, 1),
(108, 4, 3),
(109, 5, 2);

-- Step 3: Query top 3 selling products by revenue
SELECT product_id, revenue
FROM (
    SELECT 
        OI.product_id,
        SUM(OI.quantity * P.price) AS revenue,
        RANK() OVER (ORDER BY SUM(OI.quantity * P.price) DESC) AS rank
    FROM Order_Items OI
    JOIN Products P ON OI.product_id = P.product_id
    GROUP BY OI.product_id
) ranked_products
WHERE rank <= 3;



PRODUCT_ID	REVENUE
4	1250.00
3	1000.00
5	900.00
