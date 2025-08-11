-- 47. Complaint Management System 
-- Objective: Track public complaints and resolutions. 
-- Entities: 
-- • Complaints 
-- • Departments 
-- • Responses 
-- SQL Skills: 
-- • Status summary 
-- • Department workload 
-- Tables: 
-- • complaints (id, title, department_id, status) 
-- • departments (id, name) 
-- • responses (complaint_id, responder_id, message)

CREATE DATABASE complaint_management;
USE complaint_management;

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    department_id INT,
    status ENUM('Open', 'In Progress', 'Resolved') DEFAULT 'Open',
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE
);

CREATE TABLE responses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT,
    responder_id INT,
    message TEXT NOT NULL,
    FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
);

INSERT INTO departments (name) VALUES
('Customer Service'), ('Technical Support'), ('Billing');

INSERT INTO complaints (title, department_id, status) VALUES
('Late product delivery', 1, 'Open'),
('App crashes frequently', 2, 'In Progress'),
('Incorrect billing amount', 3, 'Resolved');

INSERT INTO responses (complaint_id, responder_id, message) VALUES
(1, 101, 'We are investigating your delivery issue'),
(2, 102, 'Our engineers are working on a fix');

-- Query: Department workload summary
SELECT d.name, COUNT(c.id) AS total_complaints
FROM complaints c
JOIN departments d ON c.department_id = d.id
GROUP BY d.name;
