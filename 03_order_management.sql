-- 3. Order Management System 
-- Objective: Store placed orders and track their statuses. 
-- Entities: 
-- • Users 
-- • Orders 
-- • Products 
-- • Order Items 
-- SQL Skills: 
-- • Transactions 
-- • JOINs and GROUP BY 
-- • Status tracking with enums 
-- • Query to get order history by user 
-- Tables: 
-- • orders (id, user_id, status, created_at) 
-- • order_items (id, order_id, product_id, quantity, price)


CREATE DATABASE IF NOT EXISTS order_management_db;
USE order_management_db;

-- table: users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

--  table: products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

--  table: orders
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- table: order_items
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL, 
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert sample users
INSERT INTO users (name, email) VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

-- Insert sample products
INSERT INTO products (name, price, stock) VALUES 
('Tablet', 15000.00, 20),
('Smartwatch', 8000.00, 30),
('Wireless Earbuds', 3000.00, 50);

-- Insert sample orders
INSERT INTO orders (user_id, status) VALUES 
(1, 'Pending'),
(2, 'Shipped');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 15000.00),  -- Alice bought 1 Tablet
(1, 3, 2, 3000.00),   -- Alice bought 2 Earbuds
(2, 2, 1, 8000.00);   -- Bob bought 1 Smartwatch


-- Start transaction 
START TRANSACTION;

-- 1. Insert into orders
INSERT INTO orders (user_id, status) VALUES (1, 'Pending');
-- Get last inserted order_id
SET @last_order_id = LAST_INSERT_ID();

-- 2. Insert into order_items for this order
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES
(@last_order_id, 2, 1, 8000.00),
(@last_order_id, 3, 3, 3000.00);

-- 3. Commit the transaction
COMMIT;


-- 1. Get order history for a user with item breakdown (e.g., user_id = 1)
SELECT o.id AS order_id, o.status, o.created_at, p.name AS product, oi.quantity, oi.price, (oi.quantity * oi.price) AS total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;

-- 2. Get total value per order for a user (GROUP BY order)
SELECT o.id AS order_id, o.created_at, o.status,
       SUM(oi.quantity * oi.price) AS order_total
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = 1
GROUP BY o.id, o.created_at, o.status
ORDER BY o.created_at DESC;

-- 3. Get all 'Pending' orders
SELECT o.id AS order_id, u.name AS customer, o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.status = 'Pending';

-- 4. Update order status (e.g., mark order 1 as Delivered)
UPDATE orders
SET status = 'Delivered'
WHERE id = 1;
