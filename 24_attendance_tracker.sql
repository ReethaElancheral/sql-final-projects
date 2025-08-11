-- 24. Attendance Tracker 
-- Objective: Record daily student attendance. 
-- Entities: 
-- • Students 
-- • Courses 
-- • Attendance 
-- SQL Skills: 
-- • Date logic 
-- • Summary per student/course 
-- Tables: 
-- • students (id, name) 
-- • courses (id, name) 
-- • attendance (student_id, course_id, date, status)

CREATE DATABASE attendance_tracker_db;
USE attendance_tracker_db;

CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE attendance (
    student_id INT,
    course_id INT,
    date DATE,
    status ENUM('Present', 'Absent'),
    PRIMARY KEY (student_id, course_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO students (name) VALUES ('John Doe'), ('Jane Smith');
INSERT INTO courses (name) VALUES ('Math'), ('Science');

INSERT INTO attendance VALUES
(1, 1, '2025-08-01', 'Present'),
(2, 1, '2025-08-01', 'Absent');


SELECT course_id, COUNT(*) AS total_present
FROM attendance
WHERE status = 'Present'
GROUP BY course_id;
