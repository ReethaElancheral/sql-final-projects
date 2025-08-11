-- 42. Vehicle Rental System 
-- Objective: Track vehicle availability and rentals. 
-- Entities: 
-- • Vehicles 
-- • Customers 
-- • Rentals 
-- SQL Skills: 
-- • Duration-based charge calculation 
-- • Vehicle availability 
-- Tables: 
-- • vehicles (id, type, plate_number) 
-- • customers (id, name) 
-- • rentals (vehicle_id, customer_id, start_date, end_date)

CREATE DATABASE vehicle_rental;
USE vehicle_rental;

CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,
    plate_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE rentals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT,
    customer_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

INSERT INTO vehicles (type, plate_number) VALUES
('Sedan', 'ABC-123'),
('SUV', 'XYZ-789'),
('Truck', 'TRK-555');

INSERT INTO customers (name) VALUES
('David Kim'), ('Emma Watson'), ('Liam Brown');

INSERT INTO rentals (vehicle_id, customer_id, start_date, end_date) VALUES
(1, 1, '2025-08-10', '2025-08-12'),
(2, 2, '2025-08-11', '2025-08-15'),
(3, 3, '2025-08-13', '2025-08-18');

-- Query: Calculate rental days and charges (assuming $50/day)
SELECT r.id, c.name, v.type, 
       DATEDIFF(r.end_date, r.start_date) AS rental_days,
       DATEDIFF(r.end_date, r.start_date) * 50 AS total_charge
FROM rentals r
JOIN vehicles v ON r.vehicle_id = v.id
JOIN customers c ON r.customer_id = c.id;