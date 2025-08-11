-- 17. Invoice Generator 
-- Objective: Create invoices with multiple line items. 
-- Entities: 
-- • Clients 
-- • Invoices 
-- • Invoice Items 
-- SQL Skills: 
-- • Subtotal/total calculations 
-- • JOINs between invoice and items 
-- Tables: 
-- • clients (id, name) 
-- • invoices (id, client_id, date) 
-- • invoice_items (invoice_id, description, quantity, rate)


CREATE DATABASE IF NOT EXISTS invoice_generator_db;
USE invoice_generator_db;



-- Clients Table
CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Invoices Table
CREATE TABLE invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

-- Invoice Items Table
CREATE TABLE invoice_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    rate DECIMAL(10,2) NOT NULL CHECK (rate >= 0),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);



INSERT INTO clients (name) VALUES
('ABC Corp'),
('XYZ Solutions');

INSERT INTO invoices (client_id, date) VALUES
(1, '2025-08-01'),
(1, '2025-08-05'),
(2, '2025-08-07');

INSERT INTO invoice_items (invoice_id, description, quantity, rate) VALUES
(1, 'Website Development', 1, 1200.00),
(1, 'Hosting (12 months)', 1, 150.00),
(2, 'SEO Optimization', 1, 500.00),
(3, 'Software License', 3, 200.00),
(3, 'Setup Fee', 1, 100.00);



-- 1. Get invoice details with line item subtotals
SELECT 
    i.id AS invoice_id,
    c.name AS client_name,
    i.date,
    ii.description,
    ii.quantity,
    ii.rate,
    (ii.quantity * ii.rate) AS line_total
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
ORDER BY i.id, ii.id;

-- 2. Calculate total amount per invoice
SELECT 
    i.id AS invoice_id,
    c.name AS client_name,
    i.date,
    SUM(ii.quantity * ii.rate) AS total_amount
FROM invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id, c.name, i.date
ORDER BY i.date DESC;

-- 3. Get all invoices for a specific client
SELECT 
    i.id AS invoice_id,
    i.date,
    SUM(ii.quantity * ii.rate) AS total_amount
FROM invoices i
JOIN invoice_items ii ON i.id = ii.invoice_id
WHERE i.client_id = 1
GROUP BY i.id, i.date
ORDER BY i.date DESC;
