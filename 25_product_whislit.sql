-- 25. Product Wishlist System 
-- Objective: Let users save favorite products. 
-- Entities: 
-- • Users 
-- • Products 
-- • Wishlist 
-- SQL Skills: 
-- • Many-to-many 
-- • Query popular wishlist items 
-- Tables: 
-- • users (id, name) 
-- • products (id, name) 
-- • wishlist (user_id, product_id)

CREATE DATABASE wishlist_system_db;
USE wishlist_system_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE wishlist (
    user_id INT,
    product_id INT,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO users (name) VALUES ('Alice'), ('Bob');
INSERT INTO products (name) VALUES ('Laptop'), ('Phone');

INSERT INTO wishlist VALUES (1, 1), (2, 1), (1, 2);


SELECT p.name, COUNT(w.user_id) AS wish_count
FROM products p
LEFT JOIN wishlist w ON p.id = w.product_id
GROUP BY p.id;
