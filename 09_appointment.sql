-- 9. Appointment Scheduler 
-- Objective: Track appointments booked by users. 
-- Entities: 
-- • Users 
-- • Services 
-- • Appointments 
-- SQL Skills: 
-- • Time clash logic 
-- • Filters by date and service 
-- Tables: 
-- • users (id, name) 
-- • services (id, name) 
-- • appointments (id, user_id, service_id, appointment_time)


CREATE DATABASE IF NOT EXISTS appointment_scheduler_db;
USE appointment_scheduler_db;



CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);


INSERT INTO users (name) VALUES 
('Nina'), 
('Karan'), 
('Sara');

INSERT INTO services (name) VALUES 
('Haircut'), 
('Massage'), 
('Manicure');

INSERT INTO appointments (user_id, service_id, appointment_time) VALUES
(1, 1, '2025-08-10 10:00:00'),
(2, 2, '2025-08-10 11:00:00'),
(3, 1, '2025-08-10 12:00:00');


-- Trigger: Prevent Time Clash


DELIMITER $$

CREATE TRIGGER trg_prevent_time_clash
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
    DECLARE clash_count INT;

    -- Check for existing appointment for same service at same time
    SELECT COUNT(*) INTO clash_count
    FROM appointments
    WHERE service_id = NEW.service_id
      AND appointment_time = NEW.appointment_time;

    IF clash_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment time clash for this service.';
    END IF;
END$$

DELIMITER ;


-- 1. Get all appointments for a given date (e.g., '2025-08-10')
SELECT 
    a.id,
    u.name AS user,
    s.name AS service,
    a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE DATE(a.appointment_time) = '2025-08-10'
ORDER BY a.appointment_time;

-- 2. Get all appointments for a particular service (e.g., service_id = 1)
SELECT 
    a.id,
    u.name AS user,
    s.name AS service,
    a.appointment_time
FROM appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE a.service_id = 1
ORDER BY a.appointment_time;

-- 3. Get upcoming appointments for a user (e.g., user_id = 1)
SELECT 
    a.id,
    s.name AS service,
    a.appointment_time
FROM appointments a
JOIN services s ON a.service_id = s.id
WHERE a.user_id = 1
  AND a.appointment_time > NOW()
ORDER BY a.appointment_time;
