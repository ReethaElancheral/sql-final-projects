-- 49. Payment Subscription Tracker 
-- Objective: Track recurring subscriptions and renewal dates. 
-- Entities: 
-- • Users 
-- • Subscriptions 
-- SQL Skills: 
-- • Auto-renewal date logic 
-- • Expired subscription check 
-- Tables: 
-- • users (id, name) 
-- • subscriptions (id, user_id, plan_name, start_date, renewal_cycle)


CREATE DATABASE subscription_tracker;
USE subscription_tracker;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    renewal_cycle ENUM('Monthly', 'Yearly') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alex Carter'), ('Nina Gomez'), ('Robert Fox');

INSERT INTO subscriptions (user_id, plan_name, start_date, renewal_cycle) VALUES
(1, 'Premium', '2025-08-01', 'Monthly'),
(2, 'Basic', '2025-05-15', 'Yearly'),
(3, 'Pro', '2025-07-10', 'Monthly');

-- Query: Find expired monthly subscriptions (30 days cycle)
SELECT u.name, s.plan_name, s.start_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE s.renewal_cycle = 'Monthly'
AND DATE_ADD(s.start_date, INTERVAL 30 DAY) < CURDATE();