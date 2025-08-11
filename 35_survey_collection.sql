-- 35. Survey Collection System 
-- Objective: Store responses for surveys and analyze results. 
-- Entities: 
-- • Surveys 
-- • Questions 
-- • Responses 
-- SQL Skills: 
-- • COUNT and GROUP BY 
-- • Pivot-style summaries 
-- Tables: 
-- • surveys (id, title) 
-- • questions (id, survey_id, question_text) 
-- • responses (user_id, question_id, answer_text)

CREATE DATABASE survey_db;
USE survey_db;

CREATE TABLE surveys (
    id INT PRIMARY KEY,
    title VARCHAR(100)
);

CREATE TABLE questions (
    id INT PRIMARY KEY,
    survey_id INT,
    question_text TEXT,
    FOREIGN KEY (survey_id) REFERENCES surveys(id)
);

CREATE TABLE responses (
    user_id INT,
    question_id INT,
    answer_text TEXT,
    PRIMARY KEY (user_id, question_id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO surveys VALUES
(1, 'Customer Satisfaction Survey');

INSERT INTO questions VALUES
(1, 1, 'How satisfied are you with our service?'),
(2, 1, 'Would you recommend us?');

INSERT INTO responses VALUES
(1, 1, 'Very satisfied'),
(1, 2, 'Yes'),
(2, 1, 'Neutral'),
(2, 2, 'No');

-- Query: Count responses per answer
SELECT q.question_text, r.answer_text, COUNT(*) AS count_responses
FROM responses r
JOIN questions q ON r.question_id = q.id
GROUP BY q.question_text, r.answer_text;
