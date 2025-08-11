-- 27. Notification System 
-- Objective: Store user notifications and read status. 
-- Entities: 
-- • Users 
-- • Notifications 
-- SQL Skills: 
-- • Unread count 
-- • Mark-as-read logic 
-- Tables: 
-- • notifications (id, user_id, message, status, created_at)


CREATE DATABASE notification_system_db;
USE notification_system_db;

CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message VARCHAR(255),
    status ENUM('Unread', 'Read') DEFAULT 'Unread',
    created_at DATETIME
);

INSERT INTO notifications (user_id, message, status, created_at) VALUES
(1, 'Welcome!', 'Unread', '2025-08-01 10:00:00'),
(1, 'You have a new message.', 'Read', '2025-08-02 10:00:00');


SELECT COUNT(*) AS unread_count
FROM notifications
WHERE status = 'Unread';
