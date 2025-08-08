-- 4. Inventory Tracking System 
-- Objective: Manage product stock levels and inventory history. 
-- Entities: 
-- • Products 
-- • Suppliers 
-- • Inventory Logs 
-- SQL Skills: 
-- • Triggers to auto-update stock 
-- • Reorder logic with CASE WHEN 
-- • Query to get stock status 
-- Tables: 
-- • products (id, name, stock) 
-- • suppliers (id, name) 
-- • inventory_logs (id, product_id, supplier_id, action, qty, 
-- timestamp)


CREATE DATABASE IF NOT EXISTS inventory_db;
USE inventory_db;

--  table: products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

--  table: suppliers
CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

--  table: inventory_logs
CREATE TABLE inventory_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    supplier_id INT,
    action ENUM('IN', 'OUT') NOT NULL,  -- IN = restock, OUT = reduce stock
    qty INT NOT NULL CHECK (qty > 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);


-- Trigger: Auto-update stock


DELIMITER $$

CREATE TRIGGER trg_update_stock
AFTER INSERT ON inventory_logs
FOR EACH ROW
BEGIN
    IF NEW.action = 'IN' THEN
        UPDATE products
        SET stock = stock + NEW.qty
        WHERE id = NEW.product_id;
    ELSEIF NEW.action = 'OUT' THEN
        UPDATE products
        SET stock = stock - NEW.qty
        WHERE id = NEW.product_id;
    END IF;
END$$

DELIMITER ;



-- Insert suppliers
INSERT INTO suppliers (name) VALUES 
('ABC Distributors'),
('XYZ Supplies');

-- Insert products
INSERT INTO products (name, stock) VALUES 
('Printer', 10),
('Monitor', 15),
('Keyboard', 25);

-- Insert inventory logs
INSERT INTO inventory_logs (product_id, supplier_id, action, qty) VALUES
(1, 1, 'IN', 20),     -- Printer +20
(2, 2, 'OUT', 5),     -- Monitor -5
(3, 1, 'IN', 10),     -- Keyboard +10
(1, 1, 'OUT', 15);    -- Printer -15



-- 1. View all products with current stock and reorder status
SELECT 
    id AS product_id,
    name,
    stock,
    CASE 
        WHEN stock <= 5 THEN 'Low Stock - Reorder'
        WHEN stock BETWEEN 6 AND 20 THEN 'Sufficient'
        ELSE 'High Stock'
    END AS reorder_status
FROM products;

-- 2. View inventory log history with product and supplier
SELECT 
    il.id, 
    p.name AS product, 
    s.name AS supplier,
    il.action, 
    il.qty, 
    il.timestamp
FROM inventory_logs il
LEFT JOIN products p ON il.product_id = p.id
LEFT JOIN suppliers s ON il.supplier_id = s.id
ORDER BY il.timestamp DESC;

-- 3. Get total stock in warehouse
SELECT SUM(stock) AS total_stock FROM products;

-- 4. Get stock for each product with total quantity added and removed
SELECT 
    p.id, 
    p.name, 
    p.stock,
    SUM(CASE WHEN il.action = 'IN' THEN il.qty ELSE 0 END) AS total_added,
    SUM(CASE WHEN il.action = 'OUT' THEN il.qty ELSE 0 END) AS total_removed
FROM products p
LEFT JOIN inventory_logs il ON p.id = il.product_id
GROUP BY p.id, p.name, p.stock;
