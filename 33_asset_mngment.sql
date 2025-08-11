-- 33. Asset Management System 
-- Objective: Track company assets, users, and assignment history. 
-- Entities: 
-- • Assets 
-- • Users 
-- • Assignments 
-- SQL Skills: 
-- • Current vs historical usage tracking 
-- • Asset availability queries 
-- Tables: 
-- • assets (id, name, category) 
-- • users (id, name) 
-- • assignments (asset_id, user_id, assigned_date, returned_date)

CREATE DATABASE asset_mgmt_db;
USE asset_mgmt_db;

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE assets (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE assignments (
    asset_id INT,
    user_id INT,
    assigned_date DATE,
    returned_date DATE NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users VALUES
(1, 'John Doe'),
(2, 'Jane Smith');

INSERT INTO assets VALUES
(1, 'Laptop Dell', 'Electronics'),
(2, 'Office Chair', 'Furniture');

INSERT INTO assignments VALUES
(1, 1, '2025-07-01', NULL),
(2, 2, '2025-06-01', '2025-07-15');

-- Query: Currently assigned assets
SELECT a.name, u.name AS assigned_to
FROM assignments asg
JOIN assets a ON asg.asset_id = a.id
JOIN users u ON asg.user_id = u.id
WHERE asg.returned_date IS NULL;
