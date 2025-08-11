-- 36. IT Support Ticket System 
-- Objective: Track support tickets and resolution time. 
-- Entities: 
-- • Users 
-- • Tickets 
-- • Support Staff 
-- SQL Skills: 
-- • Average resolution time 
-- • Ticket volume by category 
-- Tables: 
-- • tickets (id, user_id, issue, status, created_at, resolved_at) 
-- • support_staff (id, name) 
-- • assignments (ticket_id, staff_id)

CREATE DATABASE support_ticket_db;
USE support_ticket_db;

CREATE TABLE tickets (
    id INT PRIMARY KEY,
    user_id INT,
    issue TEXT,
    status VARCHAR(20),
    created_at DATETIME,
    resolved_at DATETIME NULL
);

CREATE TABLE support_staff (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE assignments (
    ticket_id INT,
    staff_id INT,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (staff_id) REFERENCES support_staff(id)
);

INSERT INTO tickets VALUES
(1, 101, 'System crash on login', 'Resolved', '2025-08-01 09:00:00', '2025-08-01 11:00:00'),
(2, 102, 'Email not syncing', 'Open', '2025-08-02 14:00:00', NULL);

INSERT INTO support_staff VALUES
(1, 'Mike'),
(2, 'Sarah');

INSERT INTO assignments VALUES
(1, 1),
(2, 2);

-- Query: Average resolution time in hours
SELECT AVG(TIMESTAMPDIFF(HOUR, created_at, resolved_at)) AS avg_resolution_hours
FROM tickets
WHERE resolved_at IS NOT NULL;
