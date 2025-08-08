-- 8. Sales CRM Tracker 
-- Objective: Monitor leads and deals status across stages. 
-- Entities: 
-- • Users 
-- • Leads 
-- • Deals 
-- • Statuses 
-- SQL Skills: 
-- • CTEs or Window functions for deal progression 
-- • Filters by status/date 
-- Tables: 
-- • users (id, name) 
-- • leads (id, name, source) 
-- • deals (id, lead_id, user_id, stage, amount, created_at)


CREATE DATABASE IF NOT EXISTS sales_crm_db;
USE sales_crm_db;


-- Users (Sales Reps)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Leads (Potential Customers)
CREATE TABLE leads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    source VARCHAR(100)
);

-- Deals (Linked to a lead and a user)
CREATE TABLE deals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NOT NULL,
    user_id INT NOT NULL,
    stage ENUM('New', 'Contacted', 'Qualified', 'Proposal Sent', 'Won', 'Lost') NOT NULL,
    amount DECIMAL(10,2),
    created_at DATE NOT NULL,
    FOREIGN KEY (lead_id) REFERENCES leads(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- Insert users
INSERT INTO users (name) VALUES
('Amit Shah'),
('Priya Desai'),
('Ravi Kumar');

-- Insert leads
INSERT INTO leads (name, source) VALUES
('John Traders', 'Website'),
('Global Corp', 'Referral'),
('Bright Solutions', 'Email'),
('Fast Movers', 'Cold Call');

-- Insert deals
INSERT INTO deals (lead_id, user_id, stage, amount, created_at) VALUES
(1, 1, 'New', 10000.00, '2025-08-01'),
(1, 1, 'Contacted', 10000.00, '2025-08-02'),
(1, 1, 'Proposal Sent', 10000.00, '2025-08-04'),
(1, 1, 'Won', 10000.00, '2025-08-06'),

(2, 2, 'New', 20000.00, '2025-08-01'),
(2, 2, 'Contacted', 20000.00, '2025-08-03'),
(2, 2, 'Lost', 20000.00, '2025-08-05'),

(3, 3, 'New', 15000.00, '2025-08-01'),

(4, 1, 'New', 25000.00, '2025-08-02'),
(4, 1, 'Contacted', 25000.00, '2025-08-03'),
(4, 1, 'Qualified', 25000.00, '2025-08-04');


-- 1. Latest deal stage per lead using window function
WITH ranked_deals AS (
    SELECT 
        d.*,
        ROW_NUMBER() OVER (PARTITION BY lead_id ORDER BY created_at DESC) AS rn
    FROM deals d
)
SELECT 
    r.lead_id,
    l.name AS lead_name,
    u.name AS assigned_user,
    r.stage AS latest_stage,
    r.amount,
    r.created_at
FROM ranked_deals r
JOIN leads l ON r.lead_id = l.id
JOIN users u ON r.user_id = u.id
WHERE r.rn = 1;

-- 2. All deals currently in a specific stage (e.g., 'Contacted')
WITH latest_stage AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY lead_id ORDER BY created_at DESC) AS rn
    FROM deals
)
SELECT 
    d.lead_id,
    l.name AS lead_name,
    u.name AS user_name,
    d.stage,
    d.amount,
    d.created_at
FROM latest_stage d
JOIN leads l ON d.lead_id = l.id
JOIN users u ON d.user_id = u.id
WHERE d.rn = 1 AND d.stage = 'Contacted';

-- 3. Total deal amount per user by final deal stage
WITH final_stage AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY lead_id ORDER BY created_at DESC) AS rn
    FROM deals
)
SELECT 
    u.name AS user_name,
    d.stage AS final_stage,
    COUNT(*) AS total_deals,
    SUM(d.amount) AS total_amount
FROM final_stage d
JOIN users u ON d.user_id = u.id
WHERE d.rn = 1
GROUP BY u.name, d.stage
ORDER BY u.name;

-- 4. Deals created in a given date range (e.g., August 2025)
SELECT 
    d.id,
    l.name AS lead_name,
    u.name AS sales_rep,
    d.stage,
    d.amount,
    d.created_at
FROM deals d
JOIN leads l ON d.lead_id = l.id
JOIN users u ON d.user_id = u.id
WHERE d.created_at BETWEEN '2025-08-01' AND '2025-08-31'
ORDER BY d.created_at;
