-- =================================
-- STEP 7b: INSIGHTS - one headline table that feeds the README / slides
-- =================================

WITH base AS (SELECT * FROM fsa_rated),
borough AS (
    SELECT local_authority_name,
           AVG(is_five_star::INT) * 100 AS p5,
           AVG(is_low_rated::INT) * 100 AS plow
    FROM base GROUP BY 1 HAVING COUNT(*) >= 30
),
btype AS (
    SELECT business_type, AVG(is_five_star::INT) * 100 AS p5, AVG(is_low_rated::INT) * 100 AS plow
    FROM base GROUP BY 1 HAVING COUNT(*) >= 30
)
SELECT 'Businesses in dataset' AS insight, (SELECT COUNT(*) FROM fsa_rating)::TEXT AS value
UNION ALL SELECT 'Businesses with a real 0-5 rating', COUNT(*)::TEXT FROM base
UNION ALL SELECT '% rated 5', ROUND(AVG(is_five_star::INT) * 100, 1)::TEXT FROM base
UNION ALL SELECT '% rated 0-2 (needs improvement)', ROUND(AVG(is_low_rated::INT) * 100, 1)::TEXT FROM base
UNION ALL SELECT 'Best borough (% five-star)',  (SELECT local_authority_name || ' - ' || ROUND(p5::NUMERIC,1) || '%' FROM borough ORDER BY p5 DESC LIMIT 1)
UNION ALL SELECT 'Worst borough (% five-star)', (SELECT local_authority_name || ' - ' || ROUND(p5::NUMERIC,1) || '%' FROM borough ORDER BY p5 ASC  LIMIT 1)
UNION ALL SELECT 'Highest low-rating share (borough)', (SELECT local_authority_name || ' - ' || ROUND(plow::NUMERIC,1) || '%' FROM borough ORDER BY plow DESC LIMIT 1)
UNION ALL SELECT 'Best business type (% five-star)',  (SELECT business_type || ' - ' || ROUND(p5::NUMERIC,1) || '%' FROM btype ORDER BY p5 DESC LIMIT 1)
UNION ALL SELECT 'Worst business type (% five-star)', (SELECT business_type || ' - ' || ROUND(p5::NUMERIC,1) || '%' FROM btype ORDER BY p5 ASC  LIMIT 1)
UNION ALL SELECT 'Highest low-rating share (type)',   (SELECT business_type || ' - ' || ROUND(plow::NUMERIC,1) || '%' FROM btype ORDER BY plow DESC LIMIT 1)
UNION ALL SELECT 'Ratings older than 3 years (%)',
    ROUND(AVG((rating_date < (SELECT MAX(rating_date) FROM base) - INTERVAL '36 months')::INT) * 100, 1)::TEXT FROM base;
