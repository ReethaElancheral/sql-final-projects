-- 45. Job Scheduling System 
-- Objective: Store and track scheduled background jobs. 
-- Entities: 
-- • Jobs 
-- • Schedules 
-- • Status Logs 
-- SQL Skills: 
-- • Last run, next run 
-- • Status count by job 
-- Tables: 
-- • jobs (id, name, frequency) 
-- • job_logs (id, job_id, run_time, status)

CREATE DATABASE job_scheduling;
USE job_scheduling;

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    frequency VARCHAR(50) NOT NULL
);

CREATE TABLE job_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    run_time DATETIME NOT NULL,
    status ENUM('Success', 'Failure') NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
);

INSERT INTO jobs (name, frequency) VALUES
('Backup Database', 'Daily'),
('Generate Reports', 'Weekly'),
('Sync Data', 'Hourly');

INSERT INTO job_logs (job_id, run_time, status) VALUES
(1, '2025-08-09 02:00:00', 'Success'),
(2, '2025-08-08 09:00:00', 'Failure'),
(3, '2025-08-10 15:00:00', 'Success');

-- Query: Count job status
SELECT j.name, jl.status, COUNT(*) AS count
FROM job_logs jl
JOIN jobs j ON jl.job_id = j.id
GROUP BY j.name, jl.status;