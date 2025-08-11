-- 20. Salary Management System 
-- Objective: Calculate monthly salaries with deductions. 
-- Entities: 
-- • Employees 
-- • Salaries 
-- • Deductions 
-- SQL Skills: 
-- • Monthly aggregation 
-- • Conditional bonus 
-- Tables: 
-- • employees (id, name) 
-- • salaries (emp_id, month, base, bonus) 
-- • deductions (emp_id, month, reason, amount) 


CREATE DATABASE IF NOT EXISTS salary_mgmt_db;
USE salary_mgmt_db;



-- Employees Table
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Salaries Table
CREATE TABLE salaries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    month DATE NOT NULL, -- store first day of the month for reference
    base DECIMAL(12,2) NOT NULL CHECK (base >= 0),
    bonus DECIMAL(12,2) DEFAULT 0 CHECK (bonus >= 0),
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- Deductions Table
CREATE TABLE deductions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    month DATE NOT NULL,
    reason VARCHAR(255),
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);



INSERT INTO employees (name) VALUES
('John Doe'),
('Mary Smith');

INSERT INTO salaries (emp_id, month, base, bonus) VALUES
(1, '2024-06-01', 3000.00, 200.00),
(1, '2024-07-01', 3000.00, 250.00),
(2, '2024-06-01', 2800.00, 0.00);

INSERT INTO deductions (emp_id, month, reason, amount) VALUES
(1, '2024-06-01', 'Late penalty', 50.00),
(1, '2024-07-01', 'Leave without pay', 100.00),
(2, '2024-06-01', 'Late penalty', 25.00);


-- 1. Monthly salary calculation with deductions
SELECT 
    e.id AS emp_id,
    e.name,
    s.month,
    s.base,
    s.bonus,
    IFNULL(SUM(d.amount), 0) AS total_deductions,
    (s.base + s.bonus - IFNULL(SUM(d.amount), 0)) AS net_salary
FROM employees e
JOIN salaries s ON e.id = s.emp_id
LEFT JOIN deductions d 
    ON e.id = d.emp_id AND s.month = d.month
GROUP BY e.id, e.name, s.month;

-- 2. Conditional bonus (e.g., give extra 100 if base salary > 2900)
SELECT 
    e.name,
    s.month,
    s.base,
    s.bonus,
    CASE 
        WHEN s.base > 2900 THEN s.bonus + 100
        ELSE s.bonus
    END AS adjusted_bonus
FROM employees e
JOIN salaries s ON e.id = s.emp_id;

-- 3. Total payroll for a month
SELECT 
    s.month,
    SUM(s.base + s.bonus - IFNULL(d.amount, 0)) AS total_payroll
FROM salaries s
LEFT JOIN (
    SELECT emp_id, month, SUM(amount) AS amount
    FROM deductions
    GROUP BY emp_id, month
) d ON s.emp_id = d.emp_id AND s.month = d.month
GROUP BY s.month;
