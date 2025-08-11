-- 13. Library Management System 
-- Objective: Manage books, members, borrow/return activity. 
-- Entities: 
-- • Books 
-- • Members 
-- • Transactions 
-- SQL Skills: 
-- • Joins and date logic 
-- • Fine calculation queries 
-- Tables: 
-- • books (id, title, author) 
-- • members (id, name) 
-- • borrows (id, member_id, book_id, borrow_date, return_date)


CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;



-- Books Table
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL
);

-- Members Table
CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Borrows Table
CREATE TABLE borrows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

INSERT INTO books (title, author) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald'),
('1984', 'George Orwell'),
('To Kill a Mockingbird', 'Harper Lee');

INSERT INTO members (name) VALUES
('Alice Johnson'),
('Bob Smith');

INSERT INTO borrows (member_id, book_id, borrow_date, return_date) VALUES
(1, 1, '2025-08-01', '2025-08-05'), -- returned
(1, 2, '2025-08-02', NULL),         -- not returned
(2, 3, '2025-08-01', '2025-08-10'); -- returned



-- 1. List all borrowed books with member details
SELECT 
    b.id AS borrow_id,
    m.name AS member_name,
    bk.title AS book_title,
    b.borrow_date,
    b.return_date
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id
ORDER BY b.borrow_date DESC;

-- 2. Get books currently borrowed (not returned)
SELECT 
    m.name AS member_name,
    bk.title AS book_title,
    b.borrow_date
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id
WHERE b.return_date IS NULL;

-- 3. Fine calculation (assuming fine = 5 per day after 7 days)
SELECT 
    m.name AS member_name,
    bk.title AS book_title,
    b.borrow_date,
    b.return_date,
    GREATEST(DATEDIFF(COALESCE(b.return_date, CURDATE()), b.borrow_date) - 7, 0) AS overdue_days,
    GREATEST(DATEDIFF(COALESCE(b.return_date, CURDATE()), b.borrow_date) - 7, 0) * 5 AS fine_amount
FROM borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id;
