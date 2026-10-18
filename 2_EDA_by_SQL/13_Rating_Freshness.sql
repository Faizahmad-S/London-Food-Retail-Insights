-- =================================
-- STEP 6 of the framework: TIME - how fresh are the ratings?
-- (fsa_rated already excludes the 1901 placeholder dates)
-- =================================

-- 13.1 Date range of real ratings
SELECT MIN(rating_date)::DATE AS first_rating, MAX(rating_date)::DATE AS last_rating FROM fsa_rated;


-- 13.2 Ratings by year of last inspection, with quality of those ratings
SELECT
    EXTRACT(YEAR FROM rating_date)::INT           AS inspection_year,
    COUNT(*)                                      AS businesses,
    ROUND(AVG(is_five_star::INT) * 100, 1)        AS pct_five_star,
    ROUND(AVG(is_low_rated::INT) * 100, 1)        AS pct_low_rated
FROM fsa_rated
WHERE rating_date >= DATE '2015-01-01'
GROUP BY 1
ORDER BY 1;
-- Careful: recent years look worse because inspectors revisit poor businesses sooner,
-- so older ratings are "survivors". This is a selection effect, NOT proof things got worse.


-- 13.3 Age of the current rating (months since last inspection, relative to newest date in data)
WITH ref AS (SELECT MAX(rating_date) AS ref_date FROM fsa_rated)
SELECT
    CASE
        WHEN rating_date >= ref_date - INTERVAL '12 months' THEN '1. under 1 year'
        WHEN rating_date >= ref_date - INTERVAL '24 months' THEN '2. 1-2 years'
        WHEN rating_date >= ref_date - INTERVAL '36 months' THEN '3. 2-3 years'
        WHEN rating_date >= ref_date - INTERVAL '60 months' THEN '4. 3-5 years'
        ELSE '5. 5+ years'
    END AS rating_age,
    COUNT(*)                                   AS businesses,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(is_low_rated::INT) * 100, 1)     AS pct_low_rated
FROM fsa_rated, ref
GROUP BY 1
ORDER BY 1;


-- 13.4 Monthly inspection volume, last 24 months + running total
WITH monthly AS (
    SELECT DATE_TRUNC('month', rating_date)::DATE AS month, COUNT(*) AS ratings
    FROM fsa_rated
    WHERE rating_date >= (SELECT MAX(rating_date) FROM fsa_rated) - INTERVAL '24 months'
    GROUP BY 1
)
SELECT month, ratings,
       SUM(ratings) OVER (ORDER BY month) AS running_total,
       ROUND(AVG(ratings) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS moving_avg_3m
FROM monthly
ORDER BY month;
