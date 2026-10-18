-- =================================
-- STEP 4 of the framework: DISTRIBUTIONS (one variable at a time)
-- Question: what does a "typical" business look like - and how skewed is it?
-- =================================

-- 10.1 Rating distribution
SELECT
    rating_num,
    COUNT(*) AS businesses,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(SUM(COUNT(*)) OVER (ORDER BY rating_num DESC) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS cumulative_pct_from_top
FROM fsa_rated
GROUP BY rating_num
ORDER BY rating_num DESC;


-- 10.2 Headline shares
SELECT
    COUNT(*) AS rated_businesses,
    ROUND(AVG(is_five_star::INT) * 100, 1)        AS pct_five_star,
    ROUND(AVG((rating_num >= 4)::INT) * 100, 1)   AS pct_four_or_five,
    ROUND(AVG(is_low_rated::INT) * 100, 1)        AS pct_low_rated_0_to_2,
    COUNT(*) FILTER (WHERE rating_num = 0)        AS rating_zero_count
FROM fsa_rated;


-- 10.3 Mean vs median vs spread for every score (a big mean-median gap = skew)
SELECT
    'hygiene' AS score,
    ROUND(AVG(scores_hygiene)::NUMERIC, 2) AS mean,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_hygiene) AS median,
    ROUND(STDDEV(scores_hygiene)::NUMERIC, 2) AS std,
    MIN(scores_hygiene) AS min, MAX(scores_hygiene) AS max
FROM fsa_rated
UNION ALL
SELECT 'structural', ROUND(AVG(scores_structural)::NUMERIC, 2),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_structural),
    ROUND(STDDEV(scores_structural)::NUMERIC, 2), MIN(scores_structural), MAX(scores_structural)
FROM fsa_rated
UNION ALL
SELECT 'confidence_in_management', ROUND(AVG(scores_confidence_in_management)::NUMERIC, 2),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY scores_confidence_in_management),
    ROUND(STDDEV(scores_confidence_in_management)::NUMERIC, 2), MIN(scores_confidence_in_management), MAX(scores_confidence_in_management)
FROM fsa_rated
UNION ALL
SELECT 'total_score', ROUND(AVG(total_score)::NUMERIC, 2),
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_score),
    ROUND(STDDEV(total_score)::NUMERIC, 2), MIN(total_score), MAX(total_score)
FROM fsa_rated;


-- 10.4 Quartiles and the long tail of total_score
SELECT
    PERCENTILE_CONT(ARRAY[0.25, 0.5, 0.75, 0.9, 0.95, 0.99])
        WITHIN GROUP (ORDER BY total_score) AS p25_p50_p75_p90_p95_p99
FROM fsa_rated;


-- 10.5 Histogram of total_score in bands of 5 (poor man's histogram)
SELECT
    (FLOOR(total_score / 5) * 5)::INT AS score_from,
    COUNT(*) AS businesses,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM fsa_rated
WHERE total_score IS NOT NULL
GROUP BY 1
ORDER BY 1;
-- Reading: most businesses sit in the lowest (best) bands; a thin tail runs to 80.
