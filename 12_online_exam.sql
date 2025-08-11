-- 12. Online Exam System 
-- Objective: Store exams, questions, and student answers. 
-- Entities: 
-- • Exams 
-- • Questions 
-- • Student Answers 
-- SQL Skills: 
-- • Join exam with answers 
-- • Calculate scores with correct answers 
-- Tables: 
-- • exams (id, course_id, date) 
-- • questions (id, exam_id, text, correct_option) 
-- • student_answers (student_id, question_id, selected_option)


CREATE DATABASE IF NOT EXISTS online_exam_db;
USE online_exam_db;

-- Exams Table
CREATE TABLE exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    date DATE NOT NULL
    -- course_id could be FK to courses table if linked with Project 11
);

-- Questions Table
CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    text TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A','B','C','D')),
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- Student Answers Table
CREATE TABLE student_answers (
    student_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_option CHAR(1) NOT NULL CHECK (selected_option IN ('A','B','C','D')),
    PRIMARY KEY (student_id, question_id),
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
    -- student_id could be FK to students table if linked with Project 11
);


INSERT INTO exams (course_id, date) VALUES
(1, '2025-08-10'),
(2, '2025-08-12');

INSERT INTO questions (exam_id, text, correct_option) VALUES
(1, 'What is the capital of France?', 'B'),
(1, 'Which is a primary key in DB?', 'A'),
(2, 'HTML stands for?', 'C');

INSERT INTO student_answers (student_id, question_id, selected_option) VALUES
(1, 1, 'B'), -- correct
(1, 2, 'C'), -- wrong
(2, 1, 'A'), -- wrong
(2, 2, 'A'); -- correct


-- 1. Get all answers for a specific exam (exam_id = 1)
SELECT 
    sa.student_id,
    q.text AS question,
    sa.selected_option,
    q.correct_option,
    CASE WHEN sa.selected_option = q.correct_option THEN 'Correct' ELSE 'Wrong' END AS result
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
WHERE q.exam_id = 1
ORDER BY sa.student_id, q.id;

-- 2. Calculate score for each student in a specific exam (exam_id = 1)
SELECT 
    sa.student_id,
    SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) AS score,
    COUNT(q.id) AS total_questions,
    CONCAT(ROUND(SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) / COUNT(q.id) * 100, 2), '%') AS percentage
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
WHERE q.exam_id = 1
GROUP BY sa.student_id;

-- 3. List students who got all answers correct in exam_id = 1
SELECT 
    sa.student_id
FROM student_answers sa
JOIN questions q ON sa.question_id = q.id
WHERE q.exam_id = 1
GROUP BY sa.student_id
HAVING SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) = COUNT(q.id);
