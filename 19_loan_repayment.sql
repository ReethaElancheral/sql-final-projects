-- 19. Loan Repayment Tracker 
-- Objective: Manage loans and monthly EMIs. 
-- Entities: 
-- • Loans 
-- • Payments 
-- SQL Skills: 
-- • SUM of paid vs total 
-- • Due date logic 
-- Tables: 
-- • loans (id, user_id, principal, interest_rate) 
-- • payments (loan_id, amount, paid_on)


CREATE DATABASE IF NOT EXISTS loan_tracker_db;
USE loan_tracker_db;


-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Loans Table
CREATE TABLE loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    principal DECIMAL(12,2) NOT NULL CHECK (principal > 0),
    interest_rate DECIMAL(5,2) NOT NULL CHECK (interest_rate >= 0), -- % per annum
    start_date DATE NOT NULL,
    term_months INT NOT NULL CHECK (term_months > 0),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    paid_on DATE NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE
);



INSERT INTO users (name) VALUES
('Alice Johnson'),
('Bob Smith');

INSERT INTO loans (user_id, principal, interest_rate, start_date, term_months) VALUES
(1, 10000.00, 5.0, '2024-01-01', 12), -- 1 year loan
(2, 5000.00, 4.5, '2024-03-01', 6);  -- 6 month loan

INSERT INTO payments (loan_id, amount, paid_on) VALUES
(1, 900.00, '2024-02-01'),
(1, 900.00, '2024-03-01'),
(2, 850.00, '2024-04-01');



-- 1. Total paid vs total due for each loan
SELECT 
    l.id AS loan_id,
    u.name AS borrower,
    l.principal,
    l.interest_rate,
    (l.principal + (l.principal * l.interest_rate / 100)) AS total_due,
    IFNULL(SUM(p.amount), 0) AS total_paid,
    ( (l.principal + (l.principal * l.interest_rate / 100)) - IFNULL(SUM(p.amount), 0) ) AS balance_remaining
FROM loans l
JOIN users u ON l.user_id = u.id
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

-- 2. EMI Calculation (simple formula: (Principal + Interest) / Term Months)
SELECT 
    l.id AS loan_id,
    u.name AS borrower,
    ROUND((l.principal + (l.principal * l.interest_rate / 100)) / l.term_months, 2) AS monthly_emi
FROM loans l
JOIN users u ON l.user_id = u.id;

-- 3. Due date logic: List loans with next payment due date
SELECT 
    l.id AS loan_id,
    u.name AS borrower,
    DATE_ADD(l.start_date, INTERVAL COUNT(p.id) MONTH) AS next_due_date
FROM loans l
JOIN users u ON l.user_id = u.id
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;
