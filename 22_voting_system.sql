-- 22. Voting System 
-- Objective: Let users vote on topics and options. 
-- Entities: 
-- • Polls 
-- • Options 
-- • Votes 
-- SQL Skills: 
-- • COUNT votes by option 
-- • Prevent duplicate votes per user 
-- Tables: 
-- • polls (id, question) 
-- • options (id, poll_id, option_text) 
-- • votes (user_id, option_id, voted_at)

CREATE DATABASE voting_system_db;
USE voting_system_db;

CREATE TABLE polls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question VARCHAR(255)
);

CREATE TABLE options (
    id INT PRIMARY KEY AUTO_INCREMENT,
    poll_id INT,
    option_text VARCHAR(255),
    FOREIGN KEY (poll_id) REFERENCES polls(id)
);

CREATE TABLE votes (
    user_id INT,
    option_id INT,
    voted_at DATETIME,
    PRIMARY KEY (user_id, option_id),
    FOREIGN KEY (option_id) REFERENCES options(id)
);

INSERT INTO polls (question) VALUES
('What is your favorite programming language?');

INSERT INTO options (poll_id, option_text) VALUES
(1, 'Python'), (1, 'JavaScript'), (1, 'C++');

INSERT INTO votes (user_id, option_id, voted_at) VALUES
(1, 1, '2025-08-01 09:00:00'),
(2, 2, '2025-08-01 09:05:00');


SELECT o.option_text, COUNT(v.user_id) AS vote_count
FROM options o
LEFT JOIN votes v ON o.id = v.option_id
GROUP BY o.id;