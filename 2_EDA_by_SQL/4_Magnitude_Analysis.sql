-- =================================
-- Exploring the Magnitudes
-- =================================

SELECT * FROM fsa_rating
LIMIT 10

-- Find total rating by authority name
SELECT 
    local_authority_name,
    COUNT(*) AS total_ratings
FROM fsa_rating
GROUP BY local_authority_name
ORDER BY total_ratings DESC;

-- Find total rating by Rating Values
SELECT 
    Rating_Value,
    COUNT(*) AS total_ratings
FROM fsa_rating
GROUP BY Rating_Value
ORDER BY total_ratings DESC;

-- Find total rating by Rating Values
SELECT 
    business_type,
    COUNT(*) AS total_ratings
FROM fsa_rating
GROUP BY business_type
ORDER BY total_ratings DESC;


-- What is a avarage overall score of each authority?
SELECT 
    local_authority_name,
    ROUND(AVG(overall_score)::NUMERIC, 2) AS total_score
FROM fsa_rating
GROUP BY local_authority_name
ORDER BY total_score ;

-- What is a avarage Hygiene score of each authority?
SELECT 
    local_authority_name,
    ROUND(AVG(scores_hygiene)::NUMERIC, 2) AS total_score
FROM fsa_rating
GROUP BY local_authority_name
ORDER BY total_score ;