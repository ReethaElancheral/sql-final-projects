-- 14. Hospital Patient Tracker 
-- Objective: Track patients, doctors, and visits. 
-- Entities: 
-- • Patients 
-- • Doctors 
-- • Visits 
-- SQL Skills: 
-- • Query patients by doctor/date 
-- • Constraints on overlapping visits 
-- Tables: 
-- • patients (id, name, dob) 
-- • doctors (id, name, specialization) 
-- • visits (id, patient_id, doctor_id, visit_time)


CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;



-- Patients Table
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL
);

-- Doctors Table
CREATE TABLE doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

-- Visits Table
CREATE TABLE visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_time DATETIME NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    CONSTRAINT uq_doctor_visit UNIQUE (doctor_id, visit_time),  -- Prevent overlapping visits for same doctor
    CONSTRAINT uq_patient_visit UNIQUE (patient_id, visit_time) -- Prevent overlapping visits for same patient
);



INSERT INTO patients (name, dob) VALUES
('John Doe', '1990-04-15'),
('Mary Smith', '1985-10-05');

INSERT INTO doctors (name, specialization) VALUES
('Dr. Alice Brown', 'Cardiology'),
('Dr. David Lee', 'Dermatology');

INSERT INTO visits (patient_id, doctor_id, visit_time) VALUES
(1, 1, '2025-08-09 09:00:00'),
(2, 1, '2025-08-09 10:00:00'),
(1, 2, '2025-08-10 14:00:00');


-- 1. Get all visits for a specific doctor on a given date
SELECT 
    v.id AS visit_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    v.visit_time
FROM visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE d.id = 1
  AND DATE(v.visit_time) = '2025-08-09'
ORDER BY v.visit_time;

-- 2. Get all visits for a specific patient
SELECT 
    v.id AS visit_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    v.visit_time
FROM visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE p.id = 1
ORDER BY v.visit_time;

-- 3. Find all doctors and their upcoming visits
SELECT 
    d.name AS doctor_name,
    p.name AS patient_name,
    v.visit_time
FROM visits v
JOIN doctors d ON v.doctor_id = d.id
JOIN patients p ON v.patient_id = p.id
WHERE v.visit_time > NOW()
ORDER BY v.visit_time;
