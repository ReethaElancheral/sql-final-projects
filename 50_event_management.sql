-- 50. Event Management System 
-- Objective: Organize and track event participants. 
-- Entities: 
-- • Events 
-- • Attendees 
-- SQL Skills: 
-- • Event-wise participant count 
-- • Capacity alerts 
-- Tables: 
-- • events (id, title, max_capacity) 
-- • attendees (event_id, user_id, registered_at)


CREATE DATABASE event_management;
USE event_management;

CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE attendees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    user_id INT,
    registered_at DATETIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

INSERT INTO events (title, max_capacity) VALUES
('Tech Conference 2025', 100),
('Music Festival', 500),
('Startup Pitch Day', 50);

INSERT INTO attendees (event_id, user_id, registered_at) VALUES
(1, 201, '2025-08-01 10:00:00'),
(1, 202, '2025-08-01 11:00:00'),
(2, 203, '2025-08-02 09:30:00');

-- Query: Participant count per event
SELECT e.title, COUNT(a.id) AS total_attendees
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.title;

-- Query: Capacity alerts
SELECT e.title, e.max_capacity, COUNT(a.id) AS total_attendees,
       CASE 
           WHEN COUNT(a.id) >= e.max_capacity THEN 'Full'
           ELSE 'Available'
       END AS status
FROM events e
LEFT JOIN attendees a ON e.id = a.event_id
GROUP BY e.id;
