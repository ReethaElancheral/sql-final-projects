-- 11. Course Enrollment System 
-- Objective: Manage courses, students, and enrollments. 
-- Entities: 
-- • Courses 
-- • Students 
-- • Enrollments 
-- SQL Skills: 
-- • Many-to-many relationships 
-- • Queries for students per course 
-- • Count enrolled students 
-- Tables: 
-- • courses (id, title, instructor) 
-- • students (id, name, email) 
-- • enrollments (course_id, student_id, enroll_date)


CREATE DATABASE IF NOT EXISTS course_enrollment_db;
USE course_enrollment_db;



-- Courses Table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    instructor VARCHAR(100) NOT NULL
);

-- Students Table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Enrollments Table (Many-to-Many Relationship)
CREATE TABLE enrollments (
    course_id INT NOT NULL,
    student_id INT NOT NULL,
    enroll_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (course_id, student_id), -- Composite PK to avoid duplicate enrollments
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);



INSERT INTO courses (title, instructor) VALUES
('Database Systems', 'Dr. Sharma'),
('Web Development', 'Ms. Kapoor'),
('Machine Learning', 'Dr. Mehta');

INSERT INTO students (name, email) VALUES
('Amit', 'amit@example.com'),
('Priya', 'priya@example.com'),
('Rahul', 'rahul@example.com'),
('Sneha', 'sneha@example.com');

INSERT INTO enrollments (course_id, student_id, enroll_date) VALUES
(1, 1, '2025-08-01'),
(1, 2, '2025-08-02'),
(2, 3, '2025-08-03'),
(2, 1, '2025-08-04'),
(3, 4, '2025-08-05');


-- 1. Get all students enrolled in a specific course (e.g., course_id = 1)
SELECT 
    c.title AS course,
    s.name AS student,
    s.email,
    e.enroll_date
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
WHERE e.course_id = 1
ORDER BY s.name;

-- 2. Count enrolled students for each course
SELECT 
    c.title AS course,
    COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY total_students DESC;

-- 3. Get all courses a specific student is enrolled in (e.g., student_id = 1)
SELECT 
    s.name AS student,
    c.title AS course,
    c.instructor,
    e.enroll_date
FROM enrollments e
JOIN courses c ON e.course_id = c.id
JOIN students s ON e.student_id = s.id
WHERE e.student_id = 1
ORDER BY e.enroll_date;
