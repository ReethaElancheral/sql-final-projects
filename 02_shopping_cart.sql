-- 2. Shopping Cart System 
-- Objective: Design a schema and queries to manage a user's shopping cart. 
-- Entities: 
-- • Users 
-- • Products 
-- • Cart Items 
-- SQL Skills: 
-- • Composite primary keys 
-- • JOINS to retrieve product details in the cart 
-- • SUM to calculate total cart value 
-- • INSERT, UPDATE, DELETE for cart operations 
-- Tables: 
-- • users (id, name, email) 
-- • carts (id, user_id) 
-- • cart_items (cart_id, product_id, quantity)


-- Create the database
CREATE DATABASE IF NOT EXISTS shopping_cart_db;
USE shopping_cart_db;

-- Create table: users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

--  table: products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

--  table: carts
CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

--  table: cart_items
CREATE TABLE cart_items (
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert users
INSERT INTO users (name, email) VALUES 
('John Doe', 'john@example.com'),
('Jane Smith', 'jane@example.com');

-- Insert products
INSERT INTO products (name, price, stock) VALUES 
('Laptop', 75000.00, 10),
('Headphones', 2500.00, 50),
('Smartphone', 45000.00, 15),
('Backpack', 1200.00, 30);

-- Insert  carts
INSERT INTO carts (user_id) VALUES 
(1),  -- John's cart
(2);  -- Jane's cart

-- Insert  cart items
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 1),  -- John - 1 Laptop
(1, 2, 2),  -- John - 2 Headphones
(2, 3, 1),  -- Jane - 1 Smartphone
(2, 4, 3);  -- Jane - 3 Backpacks


-- 1. Get all items in a user's cart with product details (e.g., for user_id = 1)
SELECT u.name AS user, p.name AS product, p.price, ci.quantity, (p.price * ci.quantity) AS total
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN users u ON c.user_id = u.id
JOIN products p ON ci.product_id = p.id
WHERE c.user_id = 1;

-- 2. Calculate total cart value for a user (e.g., user_id = 1)
SELECT SUM(p.price * ci.quantity) AS cart_total
FROM cart_items ci
JOIN carts c ON ci.cart_id = c.id
JOIN products p ON ci.product_id = p.id
WHERE c.user_id = 1;

-- 3. Add a product to the cart (e.g., add 1 Backpack to John's cart)
INSERT INTO cart_items (cart_id, product_id, quantity)
VALUES (1, 4, 1)
ON DUPLICATE KEY UPDATE quantity = quantity + 1;

-- 4. Update quantity of a cart item (e.g., set Headphones quantity to 3 for John)
UPDATE cart_items
SET quantity = 3
WHERE cart_id = 1 AND product_id = 2;

-- 5. Remove a product from cart (e.g., remove Laptop from John's cart)
DELETE FROM cart_items
WHERE cart_id = 1 AND product_id = 1;
