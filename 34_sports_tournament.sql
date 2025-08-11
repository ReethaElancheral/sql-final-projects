-- 34. Sports Tournament Tracker 
-- Objective: Organize teams, matches, and scores. 
-- Entities: 
-- • Teams 
-- • Matches 
-- • Scores 
-- SQL Skills: 
-- • Win/loss stats 
-- • Leaderboard ranking 
-- Tables: 
-- • teams (id, name) 
-- • matches (id, team1_id, team2_id, match_date) 
-- • scores (match_id, team_id, score)

CREATE DATABASE sports_tournament_db;
USE sports_tournament_db;

CREATE TABLE teams (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE matches (
    id INT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    FOREIGN KEY (team1_id) REFERENCES teams(id),
    FOREIGN KEY (team2_id) REFERENCES teams(id)
);

CREATE TABLE scores (
    match_id INT,
    team_id INT,
    score INT,
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

INSERT INTO teams VALUES
(1, 'Lions'),
(2, 'Tigers'),
(3, 'Bears');

INSERT INTO matches VALUES
(1, 1, 2, '2025-08-05'),
(2, 2, 3, '2025-08-06');

INSERT INTO scores VALUES
(1, 1, 3),
(1, 2, 2),
(2, 2, 1),
(2, 3, 1);

-- Query: Match results with winner
SELECT m.id, t1.name AS team1, t2.name AS team2,
       CASE
         WHEN s1.score > s2.score THEN t1.name
         WHEN s2.score > s1.score THEN t2.name
         ELSE 'Draw'
       END AS winner
FROM matches m
JOIN scores s1 ON m.id = s1.match_id AND m.team1_id = s1.team_id
JOIN scores s2 ON m.id = s2.match_id AND m.team2_id = s2.team_id
JOIN teams t1 ON m.team1_id = t1.id
JOIN teams t2 ON m.team2_id = t2.id;