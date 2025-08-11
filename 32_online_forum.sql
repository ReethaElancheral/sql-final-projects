-- 32. Online Forum System 
-- Objective: Handle forum threads, posts, and replies. 
-- Entities: 
-- • Threads 
-- • Posts 
-- • Users 
-- SQL Skills: 
-- • Self joins for reply chains 
-- • Thread view aggregation 
-- Tables: 
-- • threads (id, title, user_id) 
-- • posts (id, thread_id, user_id, content, parent_post_id, 
-- posted_at)

CREATE DATABASE forum_db;
USE forum_db;

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE threads (
    id INT PRIMARY KEY,
    title VARCHAR(100),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE posts (
    id INT PRIMARY KEY,
    thread_id INT,
    user_id INT,
    content TEXT,
    parent_post_id INT NULL,
    posted_at DATETIME,
    FOREIGN KEY (thread_id) REFERENCES threads(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);

INSERT INTO users VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO threads VALUES
(1, 'Best Programming Language', 1),
(2, 'Favorite Movies', 2);

INSERT INTO posts VALUES
(1, 1, 2, 'I think Python is the best.', NULL, '2025-08-01 10:00:00'),
(2, 1, 1, 'I prefer Java.', 1, '2025-08-01 10:05:00'),
(3, 2, 3, 'Inception is my all-time favorite.', NULL, '2025-08-02 09:00:00');

-- Query: All posts with their parent content (self join)
SELECT p1.id, p1.content, p2.content AS parent_content
FROM posts p1
LEFT JOIN posts p2 ON p1.parent_post_id = p2.id;