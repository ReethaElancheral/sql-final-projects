-- 6. Employee Timesheet Tracker 
-- Objective: Store and calculate employee work logs on projects. 
-- Entities: 
-- • Employees 
-- • Projects 
-- • Timesheets 
-- SQL Skills: 
-- • JOINs to fetch timesheet per project 
-- • GROUP BY employee/project 
-- • Date filters for weekly/monthly hours 
-- Tables: 
-- • employees (id, name, dept) 
-- • projects (id, name) 
-- • timesheets (id, emp_id, project_id, hours, date)


CREATE DATABASE IF NOT EXISTS employee_timesheet_db;
USE employee_timesheet_db;

-- table: employees
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept VARCHAR(50) NOT NULL
);

--  table: projects
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

--  table: timesheets
CREATE TABLE timesheets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    project_id INT NOT NULL,
    hours DECIMAL(5,2) NOT NULL CHECK (hours >= 0),
    date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);


-- Insert employees
INSERT INTO employees (name, dept) VALUES 
('Meera', 'Design'),
('Ravi', 'Development'),
('Tina', 'Marketing');

-- Insert projects
INSERT INTO projects (name) VALUES 
('Website Redesign'),
('Mobile App'),
('Ad Campaign');

-- Insert  timesheets
INSERT INTO timesheets (emp_id, project_id, hours, date) VALUES
(1, 1, 4.0, '2025-08-01'),
(1, 1, 3.5, '2025-08-02'),
(2, 2, 6.0, '2025-08-01'),
(2, 2, 7.0, '2025-08-03'),
(3, 3, 5.0, '2025-08-02'),
(3, 3, 4.5, '2025-08-04'),
(2, 1, 2.0, '2025-08-04'); 



-- 1. Show all timesheet entries with employee and project info
SELECT 
    t.id, e.name AS employee, e.dept, p.name AS project, 
    t.hours, t.date
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
ORDER BY t.date DESC;

-- 2. Total hours logged by each employee (all projects)
SELECT 
    e.name AS employee,
    SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
GROUP BY e.id, e.name;

-- 3. Total hours per employee per project
SELECT 
    e.name AS employee,
    p.name AS project,
    SUM(t.hours) AS total_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
GROUP BY e.id, e.name, p.id, p.name
ORDER BY employee, project;

-- 4. Total hours logged this week (7-day window)
SELECT 
    e.name AS employee,
    p.name AS project,
    SUM(t.hours) AS weekly_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
WHERE t.date >= CURDATE() - INTERVAL 7 DAY
GROUP BY e.id, p.id;

-- 5. Total hours logged in August 2025
SELECT 
    e.name AS employee,
    p.name AS project,
    SUM(t.hours) AS august_hours
FROM timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
WHERE MONTH(t.date) = 8 AND YEAR(t.date) = 2025
GROUP BY e.id, p.id;
