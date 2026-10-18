-- =================================
-- Part-to-whole + Pareto: WHERE do the low ratings come from?
-- =================================

-- 12.1 Share of all businesses vs share of all LOW-rated businesses, by type
SELECT
    business_type,
    COUNT(*)                                                     AS rated_n,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)           AS pct_of_all_businesses,
    COUNT(*) FILTER (WHERE is_low_rated)                         AS low_rated_n,
    ROUND(COUNT(*) FILTER (WHERE is_low_rated) * 100.0
          / SUM(COUNT(*) FILTER (WHERE is_low_rated)) OVER (), 1) AS pct_of_all_low_rated
FROM fsa_rated
GROUP BY business_type
ORDER BY low_rated_n DESC;
-- Reading: if pct_of_all_low_rated > pct_of_all_businesses, that type is over-represented in poor ratings.


-- 12.2 Pareto by borough: how many boroughs account for half of all low ratings?
WITH low AS (
    SELECT local_authority_name, COUNT(*) AS low_rated_n
    FROM fsa_rated
    WHERE is_low_rated
    GROUP BY local_authority_name
)
SELECT
    local_authority_name,
    low_rated_n,
    ROUND(low_rated_n * 100.0 / SUM(low_rated_n) OVER (), 1)                                  AS pct_of_low,
    ROUND(SUM(low_rated_n) OVER (ORDER BY low_rated_n DESC, local_authority_name ROWS UNBOUNDED PRECEDING) * 100.0 / SUM(low_rated_n) OVER (), 1) AS cumulative_pct
FROM low
ORDER BY low_rated_n DESC;
