-- =================================
-- Analysing how a measure evolves over time. 
-- =================================

-- Number of rating on each YEAR.
-- Uses the fsa_rating view (run 9_Analysis_View.sql first) so the 1901 placeholder dates are excluded.
SELECT 
    EXTRACT(YEAR from rating_date :: DATE),
    COUNT(business_type_id) number_rating
FROM fsa_rating
GROUP BY EXTRACT(YEAR from rating_date :: DATE)
ORDER BY EXTRACT(YEAR from rating_date :: DATE)


-- number of rating of year 2026
SELECT 
    EXTRACT(MONTH from rating_date :: DATE),
    COUNT(business_type_id) number_rating
FROM fsa_rating
WHERE EXTRACT(YEAR from rating_date :: DATE) IN (2025,2026)
GROUP BY EXTRACT(MONTH from rating_date :: DATE)
ORDER BY EXTRACT(MONTH from rating_date :: DATE)