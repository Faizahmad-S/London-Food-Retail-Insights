-- =================================
-- Exploring the Measures columns
-- =================================

SELECT * FROM fsa_rating
LIMIT 10

-- Finding Mean, Median and STD of Hygiene Score
SELECT
    AVG(scores_hygiene) AS mean_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_hygiene) AS median_score,
    STDDEV(scores_hygiene) AS std_score
FROM fsa_rating;


-- Finding Mean, Median and STD of Structural Score
SELECT
    AVG(scores_structural) AS mean_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_structural) AS median_score,
    STDDEV(scores_structural) AS std_score
FROM fsa_rating;

-- Finding Mean, Median and STD of Confidence in Management Score
SELECT
    AVG(scores_confidence_in_management) AS mean_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_confidence_in_management) AS median_score,
    STDDEV(scores_confidence_in_management) AS std_score
FROM fsa_rating;

-- Note :  Lower the score better Result
-- and hygiene has the lowest values in mean and std means 
-- overall buisness do foucus more hygiene but the median values are same in all the scores

-- Finding Mean, Median and STD of Overall Score
SELECT
    AVG(overall_score) AS mean_score,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY overall_score) AS median_score,
    STDDEV(overall_score) AS std_score
FROM fsa_rating;

-- finding total number of non-null hygiene score
SELECT COUNT(scores_hygiene) AS total_hygiene_scores FROM fsa_rating

-- finding total number of non-null Structural Score
SELECT COUNT(scores_structural) AS total_structural_scores FROM fsa_rating

-- finding total number of non-null hygiene score
SELECT COUNT(scores_confidence_in_management) AS total_management_scores FROM fsa_rating

--  Generating a report
SELECT 'total_hygiene_scores' AS meausre_name , COUNT(scores_hygiene) AS meausre_value FROM fsa_rating
UNION ALL
SELECT 'total_structural_scores' AS meausre_name , COUNT(scores_structural) AS meausre_value FROM fsa_rating
UNION ALL
SELECT 'total_management_scores' AS meausre_name , COUNT(scores_confidence_in_management) AS meausre_value FROM fsa_rating
UNION ALL
SELECT 'total_overall_scores' AS meausre_name , COUNT(overall_score) AS meausre_value FROM fsa_rating