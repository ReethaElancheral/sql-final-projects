-- 30. Hotel Room Booking System 
-- Objective: Manage bookings, availability, and rooms. 
-- Entities: 
-- • Rooms 
-- • Guests 
-- • Bookings 
-- SQL Skills: 
-- • Overlap logic 
-- • Room availability query 
-- Tables: 
-- • rooms (id, number, type) 
-- • guests (id, name) 
-- • bookings (id, room_id, guest_id, from_date, to_date)

CREATE DATABASE hotel_booking_db;
USE hotel_booking_db;

CREATE TABLE rooms (
    id INT PRIMARY KEY AUTO_INCREMENT,
    number VARCHAR(10),
    type VARCHAR(50)
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT,
    guest_id INT,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (room_id) REFERENCES rooms(id),
    FOREIGN KEY (guest_id) REFERENCES guests(id)
);

INSERT INTO rooms (number, type) VALUES ('101', 'Single'), ('102', 'Double');
INSERT INTO guests (name) VALUES ('Alice'), ('Bob');

INSERT INTO bookings (room_id, guest_id, from_date, to_date) VALUES
(1, 1, '2025-08-05', '2025-08-07');


SELECT r.number, r.type
FROM rooms r
WHERE r.id NOT IN (
    SELECT room_id FROM bookings
    WHERE '2025-08-06' BETWEEN from_date AND to_date
);