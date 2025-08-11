-- 37. Food Delivery Tracker 
-- Objective: Track restaurant orders, delivery agents, and delivery times. 
-- Entities: 
-- • Orders 
-- • Restaurants 
-- • Delivery Agents 
-- SQL Skills: 
-- • Delivery time analysis 
-- • Agent workload 
-- Tables: 
-- • orders (id, restaurant_id, user_id, placed_at, delivered_at) 
-- • delivery_agents (id, name) 
-- • deliveries (order_id, agent_id)

CREATE DATABASE food_delivery_db;
USE food_delivery_db;

CREATE TABLE orders (
    id INT PRIMARY KEY,
    restaurant_id INT,
    user_id INT,
    placed_at DATETIME,
    delivered_at DATETIME
);

CREATE TABLE delivery_agents (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE deliveries (
    order_id INT,
    agent_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(id)
);

INSERT INTO orders VALUES
(1, 1, 101, '2025-08-05 12:00:00', '2025-08-05 12:45:00'),
(2, 2, 102, '2025-08-05 13:00:00', '2025-08-05 13:25:00');

INSERT INTO delivery_agents VALUES
(1, 'Alex'),
(2, 'Jamie');

INSERT INTO deliveries VALUES
(1, 1),
(2, 2);

-- Query: Average delivery time in minutes
SELECT AVG(TIMESTAMPDIFF(MINUTE, placed_at, delivered_at)) AS avg_delivery_minutes
FROM orders;