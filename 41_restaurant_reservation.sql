-- 41. Restaurant Reservation System 
-- Objective: Track reservations and table assignments. 
-- Entities: 
-- • Tables 
-- • Guests 
-- • Reservations 
-- SQL Skills: 
-- • Overlap detection 
-- • Daily summary 
-- Tables: 
-- • tables (id, table_number, capacity) 
-- • guests (id, name) 
-- • reservations (id, guest_id, table_id, date, time_slot)


CREATE DATABASE restaurant_reservation;
USE restaurant_reservation;

CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT UNIQUE NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    table_id INT,
    date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables(id) ON DELETE CASCADE
);

INSERT INTO tables (table_number, capacity) VALUES
(1, 2), (2, 4), (3, 6), (4, 2);

INSERT INTO guests (name) VALUES
('Alice Johnson'), ('Michael Smith'), ('Sophia Lee');

INSERT INTO reservations (guest_id, table_id, date, time_slot) VALUES
(1, 2, '2025-08-12', '18:00-20:00'),
(2, 1, '2025-08-12', '19:00-21:00'),
(3, 3, '2025-08-13', '18:00-20:00');

-- Query: Check daily reservations summary
SELECT date, COUNT(*) AS total_reservations
FROM reservations
GROUP BY date;

-- Query: Detect overlapping reservations for the same table
SELECT * FROM reservations r1
JOIN reservations r2
  ON r1.table_id = r2.table_id 
  AND r1.date = r2.date
  AND r1.id <> r2.id;
