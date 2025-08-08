-- 10. Project Management Tracker 
-- Objective: Track projects, tasks, and assignment status. 
-- Entities: 
-- • Projects 
-- • Tasks 
-- • Users 
-- SQL Skills: 
-- • JOINs 
-- • Status tracking and counts 
-- • User-task associations 
-- Tables: 
-- • projects (id, name) 
-- • tasks (id, project_id, name, status) 
-- • task_assignments (task_id, user_id) 


CREATE DATABASE IF NOT EXISTS project_management_db;
USE project_management_db;



CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE task_assignments (
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (task_id, user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);



-- Insert projects
INSERT INTO projects (name) VALUES 
('Website Redesign'),
('Mobile App Development');

-- Insert users
INSERT INTO users (name) VALUES 
('Anil'),
('Bina'),
('Charan');

-- Insert tasks
INSERT INTO tasks (project_id, name, status) VALUES 
(1, 'Design homepage', 'Completed'),
(1, 'Setup backend', 'In Progress'),
(1, 'Write documentation', 'Pending'),
(2, 'Develop login screen', 'In Progress'),
(2, 'Integrate payment gateway', 'Pending');

-- Assign tasks to users
INSERT INTO task_assignments (task_id, user_id) VALUES
(1, 1), 
(2, 2), 
(3, 3),
(4, 1), 
(4, 2); 



-- 1. Get all tasks with project and assigned users
SELECT 
    t.id AS task_id,
    t.name AS task_name,
    p.name AS project,
    t.status,
    GROUP_CONCAT(u.name ORDER BY u.name SEPARATOR ', ') AS assigned_users
FROM tasks t
JOIN projects p ON t.project_id = p.id
LEFT JOIN task_assignments ta ON t.id = ta.task_id
LEFT JOIN users u ON ta.user_id = u.id
GROUP BY t.id, t.name, p.name, t.status
ORDER BY p.name, t.status DESC;

-- 2. Count of tasks by status per project
SELECT
    p.name AS project,
    t.status,
    COUNT(*) AS task_count
FROM tasks t
JOIN projects p ON t.project_id = p.id
GROUP BY p.id, t.status
ORDER BY p.name, FIELD(t.status, 'Pending', 'In Progress', 'Completed');

-- 3. Tasks assigned to a specific user (e.g., user_id = 1)
SELECT 
    t.id AS task_id,
    t.name AS task_name,
    p.name AS project,
    t.status
FROM task_assignments ta
JOIN tasks t ON ta.task_id = t.id
JOIN projects p ON t.project_id = p.id
WHERE ta.user_id = 1
ORDER BY t.status DESC;

-- 4. Number of tasks assigned to each user
SELECT
    u.name AS user,
    COUNT(ta.task_id) AS assigned_tasks
FROM users u
LEFT JOIN task_assignments ta ON u.id = ta.user_id
GROUP BY u.id, u.name
ORDER BY assigned_tasks DESC;
