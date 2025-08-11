-- 15. Health Records System 
-- Objective: Store medical records and prescriptions. 
-- Entities: 
-- • Patients 
-- • Prescriptions 
-- • Medications 
-- SQL Skills: 
-- • Joins 
-- • Filter by patient/date 
-- Tables: 
-- • prescriptions (id, patient_id, date) 
-- • medications (id, name) 
-- • prescription_details (prescription_id, medication_id, dosage)


CREATE DATABASE IF NOT EXISTS health_records_db;
USE health_records_db;



-- Patients Table
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL
);

-- Medications Table
CREATE TABLE medications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Prescriptions Table
CREATE TABLE prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- Prescription Details Table
CREATE TABLE prescription_details (
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    PRIMARY KEY (prescription_id, medication_id),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE
);



INSERT INTO patients (name, dob) VALUES
('John Doe', '1990-04-15'),
('Mary Smith', '1985-10-05');

INSERT INTO medications (name) VALUES
('Amoxicillin'),
('Ibuprofen'),
('Paracetamol');

INSERT INTO prescriptions (patient_id, date) VALUES
(1, '2025-08-05'),
(1, '2025-08-09'),
(2, '2025-08-08');

INSERT INTO prescription_details (prescription_id, medication_id, dosage) VALUES
(1, 1, '500mg twice daily'),
(1, 3, '500mg three times daily'),
(2, 2, '200mg as needed'),
(3, 1, '500mg twice daily');



-- 1. Get all prescriptions for a patient by date
SELECT 
    p.id AS prescription_id,
    pr.date,
    m.name AS medication_name,
    pd.dosage
FROM prescriptions pr
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
JOIN patients p ON pr.patient_id = p.id
WHERE p.id = 1
ORDER BY pr.date DESC;

-- 2. Get all patients who were prescribed a specific medication
SELECT DISTINCT 
    pt.name AS patient_name,
    m.name AS medication_name,
    pr.date
FROM prescriptions pr
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
JOIN patients pt ON pr.patient_id = pt.id
WHERE m.name = 'Amoxicillin'
ORDER BY pr.date DESC;

-- 3. Get prescriptions within a date range for a patient
SELECT 
    pr.id AS prescription_id,
    pr.date,
    m.name AS medication_name,
    pd.dosage
FROM prescriptions pr
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
WHERE pr.patient_id = 1
  AND pr.date BETWEEN '2025-08-01' AND '2025-08-10'
ORDER BY pr.date;
