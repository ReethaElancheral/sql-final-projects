-- 28. Course Progress Tracker 
-- Objective: Monitor lesson completion per student. 
-- Entities: 
-- • Courses 
-- • Lessons 
-- • Progress 
-- SQL Skills: 
-- • Completion % calculation 
-- • JOINs and GROUP BY 
-- Tables: 
-- • courses (id, name) 
-- • lessons (id, course_id, title) 
-- • progress (student_id, lesson_id, completed_at)

CREATE DATABASE course_progress_db;
USE course_progress_db;

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE lessons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

CREATE TABLE progress (
    student_id INT,
    lesson_id INT,
    completed_at DATETIME,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

INSERT INTO courses (name) VALUES ('SQL Basics');
INSERT INTO lessons (course_id, title) VALUES
(1, 'Intro to SQL'), (1, 'SELECT Queries');

INSERT INTO progress VALUES (1, 1, '2025-08-01 10:00:00');


SELECT c.name, COUNT(p.lesson_id) / COUNT(l.id) * 100 AS completion_percentage
FROM courses c
JOIN lessons l ON c.id = l.course_id
LEFT JOIN progress p ON l.id = p.lesson_id
GROUP BY c.id;
