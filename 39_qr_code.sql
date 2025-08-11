-- 38. QR Code Entry Log System 
-- Objective: Store and track QR-based entry records. 
-- Entities: 
-- • Users 
-- • Locations 
-- • Entry Logs 
-- SQL Skills: 
-- • Count entries per location 
-- • Filter by date/time 
-- Tables: 
-- • locations (id, name) 
-- • users (id, name) 
-- • entry_logs (id, user_id, location_id, entry_time)

CREATE DATABASE qr_entry_db;
USE qr_entry_db;

CREATE TABLE locations (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE entry_logs (
    id INT PRIMARY KEY,
    user_id INT,
    location_id INT,
    entry_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

INSERT INTO locations VALUES
(1, 'Main Office'),
(2, 'Warehouse');

INSERT INTO users VALUES
(1, 'Alice'),
(2, 'Bob');

INSERT INTO entry_logs VALUES
(1, 1, 1, '2025-08-05 09:00:00'),
(2, 2, 2, '2025-08-05 09:15:00'),
(3, 1, 2, '2025-08-06 14:00:00');

-- Query: Count entries per location
SELECT l.name, COUNT(*) AS entry_count
FROM entry_logs e
JOIN locations l ON e.location_id = l.id
GROUP BY l.name;