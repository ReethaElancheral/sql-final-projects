-- 40. Freelance Project Management 
-- Objective: Match freelancers with projects and track proposals. 
-- Entities: 
-- • Freelancers 
-- • Projects 
-- • Proposals 
-- SQL Skills: 
-- • Bids and accepted proposals 
-- • Count projects per freelancer 
-- Tables: 
-- • freelancers (id, name, skill) 
-- • projects (id, client_name, title) 
-- • proposals (freelancer_id, project_id, bid_amount, status)

CREATE DATABASE freelance_db;
USE freelance_db;

CREATE TABLE freelancers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    skill VARCHAR(50)
);

CREATE TABLE projects (
    id INT PRIMARY KEY,
    client_name VARCHAR(50),
    title VARCHAR(100)
);

CREATE TABLE proposals (
    freelancer_id INT,
    project_id INT,
    bid_amount DECIMAL(10,2),
    status VARCHAR(20),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

INSERT INTO freelancers VALUES
(1, 'Alice', 'Web Development'),
(2, 'Bob', 'Graphic Design');

INSERT INTO projects VALUES
(1, 'Acme Corp', 'Website Redesign'),
(2, 'TechSoft', 'Logo Creation');

INSERT INTO proposals VALUES
(1, 1, 1500.00, 'Accepted'),
(2, 2, 500.00, 'Pending'),
(1, 2, 450.00, 'Rejected');

-- Query: Count projects per freelancer with accepted proposals
SELECT f.name, COUNT(DISTINCT p.project_id) AS accepted_projects
FROM proposals p
JOIN freelancers f ON p.freelancer_id = f.id
WHERE p.status = 'Accepted'
GROUP BY f.name;