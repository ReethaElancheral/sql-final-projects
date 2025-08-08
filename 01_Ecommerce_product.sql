-- 1. E-Commerce Product Catalog 
-- Objective: Build a catalog system to manage and retrieve product listings. 
-- Entities: 
-- • Categories (e.g., Electronics, Apparel) 
-- • Brands (e.g., Apple, Nike) 
-- • Products (name, price, stock, image, category, brand) 
-- SQL Skills: 
-- • Foreign keys for category and brand 
-- • Indexing for performance 
-- • Filtering by price, brand, category 
-- • Write queries to return product lists by category or brand 
-- Tables: 
-- • categories (id, name) 
-- • brands (id, name) 
-- • products (id, name, description, price, stock, image_url, 
-- category_id, brand_id)



CREATE DATABASE IF NOT EXISTS ecommerce_catalog;
USE ecommerce_catalog;

--  table: categories
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

--  table: brands
CREATE TABLE brands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

--  table: products
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL
);

-- Indexes for performance
CREATE INDEX idx_price ON products(price);
CREATE INDEX idx_category ON products(category_id);
CREATE INDEX idx_brand ON products(brand_id);

-- Insert sample categories
INSERT INTO categories (name) VALUES 
('Electronics'),
('Apparel'),
('Home Appliances');

-- Insert sample brands
INSERT INTO brands (name) VALUES 
('Apple'),
('Nike'),
('Samsung'),
('LG');

-- Insert sample products
INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id) VALUES
('iPhone 14', 'Latest iPhone with A15 Bionic chip', 79999.00, 50, 'https://example.com/iphone14.jpg', 1, 1),
('Nike Air Max', 'Comfortable sports shoes', 5999.00, 100, 'https://example.com/airmax.jpg', 2, 2),
('Samsung LED TV', '55-inch 4K Smart LED TV', 45999.00, 20, 'https://example.com/samsungtv.jpg', 1, 3),
('LG Refrigerator', 'Double door 300L refrigerator', 31999.00, 10, 'https://example.com/lgfridge.jpg', 3, 4),
('Apple MacBook Air', 'M2 chip lightweight laptop', 124999.00, 15, 'https://example.com/macbookair.jpg', 1, 1);



-- 1. Get all products by category (e.g., Electronics)
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE c.name = 'Electronics';

-- 2. Get all products by brand (e.g., Apple)
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE b.name = 'Apple';

-- 3. Get products with price less than ₹50,000
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE p.price < 50000;

-- 4. Get all products ordered by price descending
SELECT p.id, p.name, p.price, p.stock, c.name AS category, b.name AS brand
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
ORDER BY p.price DESC;

-- 5. Filter products by category = 'Apparel' AND brand = 'Nike'
SELECT p.id, p.name, p.price, p.stock
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE c.name = 'Apparel' AND b.name = 'Nike';

