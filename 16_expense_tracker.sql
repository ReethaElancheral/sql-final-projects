-- 16. Expense Tracker 
-- Objective: Log and categorize expenses. 
-- Entities: 
-- • Users 
-- • Categories 
-- • Expenses 
-- SQL Skills: 
-- • Aggregations by category/month 
-- • Filters by amount range 
-- Tables: 
-- • users (id, name) 
-- • categories (id, name) 
-- • expenses (id, user_id, category_id, amount, date)


CREATE DATABASE IF NOT EXISTS expense_tracker_db;
USE expense_tracker_db;



-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Categories Table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Expenses Table
CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);



INSERT INTO users (name) VALUES
('Alice Johnson'),
('Bob Williams');

INSERT INTO categories (name) VALUES
('Food'),
('Transport'),
('Entertainment'),
('Bills');

INSERT INTO expenses (user_id, category_id, amount, date) VALUES
(1, 1, 25.50, '2025-08-01'),
(1, 2, 15.00, '2025-08-03'),
(1, 4, 100.00, '2025-08-05'),
(2, 1, 40.00, '2025-08-02'),
(2, 3, 60.00, '2025-08-07'),
(2, 2, 10.00, '2025-08-09');



-- 1. Total expenses per category for a user
SELECT 
    c.name AS category,
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.id
WHERE e.user_id = 1
GROUP BY c.name
ORDER BY total_spent DESC;

-- 2. Monthly expenses for all users
SELECT 
    u.name AS user_name,
    DATE_FORMAT(e.date, '%Y-%m') AS month,
    SUM(e.amount) AS total_spent
FROM expenses e
JOIN users u ON e.user_id = u.id
GROUP BY u.name, DATE_FORMAT(e.date, '%Y-%m')
ORDER BY month DESC;

-- 3. Filter expenses in a specific amount range
SELECT 
    u.name AS user_name,
    c.name AS category,
    e.amount,
    e.date
FROM expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
WHERE e.amount BETWEEN 20 AND 50
ORDER BY e.amount DESC;
