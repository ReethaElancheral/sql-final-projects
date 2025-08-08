-- 7. Leave Management System 
-- Objective: Track employee leave requests, approvals, and balances. 
-- Entities: 
-- • Employees 
-- • Leave Types 
-- • Leave Requests 
-- SQL Skills: 
-- • Constraints on overlapping dates 
-- • Aggregate leaves by employee 
-- Tables: 
-- • employees (id, name) 
-- • leave_types (id, type_name) 
-- • leave_requests (id, emp_id, leave_type_id, from_date, to_date, 
-- status) 


CREATE DATABASE IF NOT EXISTS leave_mgmt_db;
USE leave_mgmt_db;

--  table: employees
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- table: leave_types
CREATE TABLE leave_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL
);

--  table: leave_requests
CREATE TABLE leave_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    leave_type_id INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id) ON DELETE CASCADE,
    CHECK (from_date <= to_date)
);


-- Insert employees
INSERT INTO employees (name) VALUES 
('Neha'),
('Arjun'),
('Divya');

-- Insert leave types
INSERT INTO leave_types (type_name) VALUES 
('Casual Leave'),
('Sick Leave'),
('Earned Leave');

-- Insert leave requests
INSERT INTO leave_requests (emp_id, leave_type_id, from_date, to_date, status) VALUES
(1, 1, '2025-08-05', '2025-08-06', 'Approved'),
(2, 2, '2025-08-01', '2025-08-02', 'Pending'),
(1, 3, '2025-08-10', '2025-08-12', 'Approved'),
(3, 1, '2025-08-04', '2025-08-07', 'Rejected');



-- 1. Get all leave requests with employee and leave type info
SELECT 
    lr.id,
    e.name AS employee,
    lt.type_name AS leave_type,
    lr.from_date,
    lr.to_date,
    DATEDIFF(lr.to_date, lr.from_date) + 1 AS total_days,
    lr.status
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
ORDER BY lr.from_date DESC;

-- 2. Total approved leave days per employee
SELECT 
    e.name AS employee,
    SUM(DATEDIFF(lr.to_date, lr.from_date) + 1) AS total_approved_days
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
WHERE lr.status = 'Approved'
GROUP BY e.id;

-- 3. Show all current/pending leave requests
SELECT 
    e.name AS employee,
    lt.type_name AS leave_type,
    lr.from_date,
    lr.to_date,
    lr.status
FROM leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
WHERE lr.status = 'Pending';


-- Prevent overlapping leave requests (Trigger)


DELIMITER $$

CREATE TRIGGER prevent_overlapping_leaves
BEFORE INSERT ON leave_requests
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT;

    SELECT COUNT(*) INTO overlap_count
    FROM leave_requests
    WHERE emp_id = NEW.emp_id
      AND status IN ('Pending', 'Approved')
      AND (
          (NEW.from_date BETWEEN from_date AND to_date)
          OR
          (NEW.to_date BETWEEN from_date AND to_date)
          OR
          (from_date BETWEEN NEW.from_date AND NEW.to_date)
      );

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overlapping leave request detected.';
    END IF;
END$$

DELIMITER ;
