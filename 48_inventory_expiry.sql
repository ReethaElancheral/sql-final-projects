-- 48. Inventory Expiry Tracker 
-- Objective: Monitor stock with expiry dates. 
-- Entities: 
-- • Products 
-- • Batches 
-- SQL Skills: 
-- • Expired stock alerts 
-- • Remaining stock query 
-- Tables: 
-- • products (id, name) 
-- • batches (id, product_id, quantity, expiry_date)

CREATE DATABASE inventory_expiry;
USE inventory_expiry;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE batches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    expiry_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO products (name) VALUES
('Milk'), ('Eggs'), ('Cheese');

INSERT INTO batches (product_id, quantity, expiry_date) VALUES
(1, 50, '2025-08-15'),
(2, 200, '2025-08-20'),
(3, 30, '2025-07-30');

-- Query: List expired stock
SELECT p.name, b.quantity, b.expiry_date
FROM batches b
JOIN products p ON b.product_id = p.id
WHERE b.expiry_date < CURDATE();
