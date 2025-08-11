-- 43. Product Return Management 
-- Objective: Store and manage product return requests. 
-- Entities: 
-- • Orders 
-- • Return Requests 
-- SQL Skills: 
-- • JOIN orders with returns 
-- • Status reporting 
-- Tables: 
-- • orders (id, user_id, product_id) 
-- • returns (id, order_id, reason, status)

CREATE DATABASE product_returns;
USE product_returns;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL
);

CREATE TABLE returns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    reason VARCHAR(255) NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

INSERT INTO orders (user_id, product_id) VALUES
(1, 101), (2, 102), (3, 103);

INSERT INTO returns (order_id, reason, status) VALUES
(1, 'Damaged on arrival', 'Pending'),
(2, 'Wrong size', 'Approved');

-- Query: List returns with order details
SELECT r.id, o.user_id, o.product_id, r.reason, r.status
FROM returns r
JOIN orders o ON r.order_id = o.id;
