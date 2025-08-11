-- 29. Recruitment Portal Database 
-- Objective: Track job applications and candidate status. 
-- Entities: 
-- • Jobs 
-- • Candidates 
-- • Applications 
-- SQL Skills: 
-- • Filter candidates by status 
-- • Job-wise applicant count 
-- Tables: 
-- • jobs (id, title, company) 
-- • candidates (id, name) 
-- • applications (job_id, candidate_id, status, applied_at)

CREATE DATABASE recruitment_portal_db;
USE recruitment_portal_db;

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    company VARCHAR(100)
);

CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE applications (
    job_id INT,
    candidate_id INT,
    status VARCHAR(50),
    applied_at DATETIME,
    PRIMARY KEY (job_id, candidate_id),
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);

INSERT INTO jobs (title, company) VALUES ('Developer', 'TechCorp');
INSERT INTO candidates (name) VALUES ('John Doe');
INSERT INTO applications VALUES (1, 1, 'Pending', '2025-08-01 09:00:00');


SELECT job_id, COUNT(*) AS applicant_count
FROM applications
GROUP BY job_id;
