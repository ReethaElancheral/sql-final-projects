-- 21. Blog Management System 
-- Objective: Store and manage blog posts and comments. 
-- Entities: 
-- • Users 
-- • Posts 
-- • Comments 
-- SQL Skills: 
-- • Joins for comments with posts 
-- • Filter posts by user or date 
-- Tables: 
-- • users (id, name) 
-- • posts (id, user_id, title, content, published_date) 
-- • comments (id, post_id, user_id, comment_text, commented_at)

CREATE DATABASE blog_management_db;
USE blog_management_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(255),
    content TEXT,
    published_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    comment_text TEXT,
    commented_at DATETIME,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name) VALUES
('Alice Johnson'), ('Bob Mehra'), ('Charlie Patel');

INSERT INTO posts (user_id, title, content, published_date) VALUES
(1, 'Welcome to Our Blog', 'First post content...', '2025-08-01 10:00:00'),
(2, 'How to use MySQL', 'Guide content...', '2025-08-02 12:30:00'),
(1, 'Top 10 SQL Tips', 'Tips content...', '2025-08-03 08:45:00');

INSERT INTO comments (post_id, user_id, comment_text, commented_at) VALUES
(1, 2, 'Great first post!', '2025-08-01 11:00:00'),
(2, 1, 'Helpful guide!', '2025-08-02 13:00:00');


SELECT p.title, u.name AS author
FROM posts p
JOIN users u ON p.user_id = u.id;

SELECT post_id, COUNT(*) AS comment_count
FROM comments
GROUP BY post_id;