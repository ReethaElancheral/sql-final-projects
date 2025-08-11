-- 23. Messaging System 
-- Objective: Store user-to-user private messages. 
-- Entities: 
-- • Users 
-- • Conversations 
-- • Messages 
-- SQL Skills: 
-- • Recent message retrieval 
-- • Threading messages by conversation 
-- Tables: 
-- • users (id, name) 
-- • conversations (id) 
-- • messages (id, conversation_id, sender_id, message_text, sent_at)

CREATE DATABASE messaging_system_db;
USE messaging_system_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE conversations (
    id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    conversation_id INT,
    sender_id INT,
    message_text TEXT,
    sent_at DATETIME,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

INSERT INTO users (name) VALUES
('Alice'), ('Bob');

INSERT INTO conversations VALUES ();

INSERT INTO messages (conversation_id, sender_id, message_text, sent_at) VALUES
(1, 1, 'Hey Bob!', '2025-08-01 08:00:00'),
(1, 2, 'Hey Alice!', '2025-08-01 08:05:00');

SELECT m.message_text, u.name
FROM messages m
JOIN users u ON m.sender_id = u.id
WHERE m.conversation_id = 1;