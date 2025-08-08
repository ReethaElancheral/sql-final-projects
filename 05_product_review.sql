-- 5. Product Review and Rating System 
-- Objective: Allow users to submit reviews and ratings for products. 
-- Entities: 
-- • Users 
-- • Products 
-- • Reviews 
-- SQL Skills: 
-- • Aggregate ratings using AVG and GROUP BY 
-- • Query to get top-rated products 
-- • Prevent duplicate reviews by same user-product 
-- Tables: 
-- • users (id, name) 
-- • products (id, name) 
-- • reviews (id, user_id, product_id, rating, review, created_at)


CREATE DATABASE IF NOT EXISTS product_reviews_db;
USE product_reviews_db;

--  table: users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

--  table: products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- table: reviews
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE (user_id, product_id)  -- Prevent duplicate reviews by same user-product
);


-- Insert  users
INSERT INTO users (name) VALUES 
('Aarav'), 
('Diya'), 
('Kabir');

-- Insert products
INSERT INTO products (name) VALUES 
('Bluetooth Speaker'),
('Fitness Band'),
('Gaming Mouse');

-- Insert  reviews
INSERT INTO reviews (user_id, product_id, rating, review) VALUES
(1, 1, 5, 'Amazing sound quality!'),
(2, 1, 4, 'Good for the price.'),
(3, 2, 3, 'Average performance.'),
(1, 3, 4, 'Great grip and precision.'),
(2, 2, 5, 'Very useful for tracking workouts.'),
(3, 1, 2, 'Not loud enough.');


-- 1. Get all reviews for a product (e.g., product_id = 1)
SELECT 
    u.name AS user, 
    r.rating, 
    r.review, 
    r.created_at
FROM reviews r
JOIN users u ON r.user_id = u.id
WHERE r.product_id = 1
ORDER BY r.created_at DESC;

-- 2. Get average rating for each product
SELECT 
    p.name AS product,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.id) AS total_reviews
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
ORDER BY average_rating DESC;

-- 3. Get top 3 highest-rated products (with at least 2 reviews)
SELECT 
    p.name AS product,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.id) AS reviews_count
FROM products p
JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
HAVING COUNT(r.id) >= 2
ORDER BY avg_rating DESC
LIMIT 3;

-- 4. Prevent duplicate review example (should fail if same user/product exists)

-- INSERT INTO reviews (user_id, product_id, rating, review) VALUES (1, 1, 5, 'Another review');
