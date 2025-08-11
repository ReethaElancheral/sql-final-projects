-- 44. Course Feedback System 
-- Objective: Collect and analyze course feedback. 
-- Entities: 
-- • Courses 
-- • Feedback 
-- SQL Skills: 
-- • Sentiment tracking 
-- • AVG rating per course 
-- Tables: 
-- • courses (id, title) 
-- • feedback (id, course_id, user_id, rating, comments)

CREATE DATABASE course_feedback;
USE course_feedback;

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL
);

CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

INSERT INTO courses (title) VALUES
('SQL Fundamentals'), ('Advanced Python'), ('Web Development');

INSERT INTO feedback (course_id, user_id, rating, comments) VALUES
(1, 1, 5, 'Very clear and helpful'),
(1, 2, 4, 'Good but a bit fast'),
(2, 3, 5, 'Excellent examples');

-- Query: Average rating per course
SELECT c.title, AVG(f.rating) AS avg_rating
FROM feedback f
JOIN courses c ON f.course_id = c.id
GROUP BY c.title;
