-- =================================
-- Exploring the Date columns
-- =================================


-- Finding fisrt and last date
SELECT 
    MIN(rating_date) AS first_rating_date,
    MAX(rating_date) AS last_rating_date
FROM fsa_rating


-- How many years between first and last date
SELECT 
    EXTRACT(year FROM AGE(MAX(rating_date) ,MIN(rating_date))) AS rating_range_year,
    (EXTRACT(year FROM AGE(MAX(rating_date) ,MIN(rating_date))) * 12
    +
    EXTRACT(MONTH FROM AGE(MAX(rating_date) ,MIN(rating_date)))) AS rating_range_month 
FROM fsa_rating


-- Counting dates only in year 2026
SELECT COUNT(rating_date) AS ratings_2026
FROM fsa_rating
WHERE rating_date :: DATE >= '2026-01-01'