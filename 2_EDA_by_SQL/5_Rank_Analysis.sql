-- =================================
-- Exploring Rank of Mesures by Dimensions 
-- =================================

-- What are top 5 best-performing authority by overall score
SELECT
    local_authority_name,
    ROUND(AVG(overall_score)::NUMERIC, 2) AS average_score
FROM fsa_rating
GROUP BY local_authority_name
ORDER BY average_score,local_authority_name
LIMIT 5;

-- What are top 5 worst-performing authority by overall score
SELECT
    local_authority_name,
    ROUND(AVG(overall_score)::NUMERIC, 2) AS average_score
FROM fsa_rating
GROUP BY local_authority_name
ORDER BY average_score DESC ,local_authority_name
LIMIT 5;

-- What are top 5 best-performing Business type by overall score
SELECT
    business_type,
    ROUND(AVG(overall_score)::NUMERIC, 2) AS average_score
FROM fsa_rating
GROUP BY business_type
ORDER BY average_score , business_type
LIMIT 5;

-- What are top 5 worst-performing Business type by overall score
SELECT
    business_type,
    ROUND(AVG(overall_score)::NUMERIC, 2) AS average_score
FROM fsa_rating
GROUP BY business_type
ORDER BY average_score DESC , business_type
LIMIT 5;