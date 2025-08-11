-- 39. Fitness Tracker Database 
-- Objective: Store workouts, users, and progress logs. 
-- Entities: 
-- • Users 
-- • Workouts 
-- • Logs 
-- SQL Skills: 
-- • Weekly summary per user 
-- • JOINs for workout type 
-- Tables: 
-- • users (id, name) 
-- • workouts (id, name, type) 
-- • workout_logs (user_id, workout_id, duration, log_date)

CREATE DATABASE fitness_db;
USE fitness_db;

CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE workouts (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    type VARCHAR(50)
);

CREATE TABLE workout_logs (
    user_id INT,
    workout_id INT,
    duration INT, -- minutes
    log_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (workout_id) REFERENCES workouts(id)
);

INSERT INTO users VALUES
(1, 'John'),
(2, 'Mary');

INSERT INTO workouts VALUES
(1, 'Running', 'Cardio'),
(2, 'Weight Lifting', 'Strength');

INSERT INTO workout_logs VALUES
(1, 1, 30, '2025-08-01'),
(1, 2, 45, '2025-08-02'),
(2, 1, 20, '2025-08-01');

-- Query: Weekly summary of total duration per user
SELECT u.name, SUM(wl.duration) AS total_minutes
FROM workout_logs wl
JOIN users u ON wl.user_id = u.id
WHERE YEARWEEK(wl.log_date) = YEARWEEK(CURDATE())
GROUP BY u.name;
