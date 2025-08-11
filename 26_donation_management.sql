-- 26. Donation Management System 
-- Objective: Track donations made to causes. 
-- Entities: 
-- • Donors 
-- • Causes 
-- • Donations 
-- SQL Skills: 
-- • SUM of donations per cause 
-- • Ranking causes by funds 
-- Tables: 
-- • donors (id, name) 
-- • causes (id, title) 
-- • donations (id, donor_id, cause_id, amount, donated_at)

CREATE DATABASE donation_system_db;
USE donation_system_db;

CREATE TABLE donors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE causes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255)
);

CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT,
    cause_id INT,
    amount DECIMAL(10,2),
    donated_at DATETIME,
    FOREIGN KEY (donor_id) REFERENCES donors(id),
    FOREIGN KEY (cause_id) REFERENCES causes(id)
);

INSERT INTO donors (name) VALUES ('Alice'), ('Bob');
INSERT INTO causes (title) VALUES ('Education'), ('Health');

INSERT INTO donations (donor_id, cause_id, amount, donated_at) VALUES
(1, 1, 100.00, '2025-08-01 09:00:00'),
(2, 2, 200.00, '2025-08-02 09:00:00');


SELECT c.title, SUM(d.amount) AS total_donations
FROM causes c
JOIN donations d ON c.id = d.cause_id
GROUP BY c.id;