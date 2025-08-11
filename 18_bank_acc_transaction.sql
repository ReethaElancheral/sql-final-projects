-- 18. Bank Account Transactions 
-- Objective: Simulate banking transactions. 
-- Entities: 
-- • Users 
-- • Accounts 
-- • Transactions 
-- SQL Skills: 
-- • CTE for balance calculation 
-- • Transaction logs 
-- Tables: 
-- • accounts (id, user_id, balance) 
-- • transactions (id, account_id, type, amount, timestamp)


CREATE DATABASE IF NOT EXISTS bank_transactions_db;
USE bank_transactions_db;



-- Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Accounts Table
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions Table
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    type ENUM('deposit','withdraw') NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);



INSERT INTO users (name) VALUES
('Alice Johnson'),
('Bob Smith');

INSERT INTO accounts (user_id, balance) VALUES
(1, 1000.00),
(2, 500.00);

INSERT INTO transactions (account_id, type, amount) VALUES
(1, 'deposit', 200.00),
(1, 'withdraw', 150.00),
(2, 'deposit', 300.00),
(2, 'withdraw', 50.00);



-- 1. Transaction log for each account
SELECT 
    t.id AS transaction_id,
    u.name AS account_holder,
    t.type,
    t.amount,
    t.timestamp
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY t.timestamp DESC;

-- 2. Current balance using CTE calculation (instead of stored balance)
WITH balance_calc AS (
    SELECT 
        account_id,
        SUM(CASE 
                WHEN type = 'deposit' THEN amount 
                WHEN type = 'withdraw' THEN -amount 
            END) AS total_change
    FROM transactions
    GROUP BY account_id
)
SELECT 
    u.name AS account_holder,
    a.id AS account_id,
    a.balance AS stored_balance,
    (a.balance + IFNULL(bc.total_change, 0)) AS recalculated_balance
FROM accounts a
JOIN users u ON a.user_id = u.id
LEFT JOIN balance_calc bc ON a.id = bc.account_id;

-- 3. All withdrawals above a certain amount
SELECT 
    u.name AS account_holder,
    t.amount,
    t.timestamp
FROM transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
WHERE t.type = 'withdraw' AND t.amount > 100
ORDER BY t.amount DESC;
