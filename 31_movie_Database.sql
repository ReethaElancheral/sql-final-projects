-- 31. Movie Database 
-- Objective: Manage information about movies, genres, and ratings. 
-- Entities: 
-- • Movies 
-- • Genres 
-- • Ratings 
-- SQL Skills: 
-- • AVG rating per movie 
-- • JOINs across genre and ratings 
-- Tables: 
-- • movies (id, title, release_year, genre_id) 
-- • genres (id, name) 
-- • ratings (user_id, movie_id, score)

CREATE DATABASE movie_db;
USE movie_db;

CREATE TABLE genres (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE movies (
    id INT PRIMARY KEY,
    title VARCHAR(100),
    release_year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    score DECIMAL(2,1),
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

INSERT INTO genres VALUES
(1, 'Action'),
(2, 'Drama'),
(3, 'Comedy');

INSERT INTO movies VALUES
(1, 'Edge of Tomorrow', 2014, 1),
(2, 'The Godfather', 1972, 2),
(3, 'The Mask', 1994, 3);

INSERT INTO ratings VALUES
(1, 1, 8.5),
(2, 1, 9.0),
(1, 2, 9.5),
(3, 3, 7.8);

-- Query: Average rating per movie
SELECT m.title, AVG(r.score) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.title;