-- =================================
-- STEP 5 of the framework: SEGMENTS - who performs better / worse?
-- Rules: (1) always show group size n  (2) ignore tiny groups  (3) compare with the London average
-- =================================

-- 11.1 Borough scorecard (ranked by % five-star)
SELECT
    local_authority_name,
    COUNT(*)                                       AS rated_n,
    ROUND(AVG(is_five_star::INT) * 100, 1)         AS pct_five_star,
    ROUND(AVG(is_low_rated::INT) * 100, 1)         AS pct_low_rated,
    ROUND(AVG(rating_num), 2)                      AS avg_rating,
    ROUND(AVG(is_five_star::INT) * 100
        - (SELECT AVG(is_five_star::INT) * 100 FROM fsa_rated), 1) AS pts_vs_london,
    RANK() OVER (ORDER BY AVG(is_five_star::INT) DESC) AS rank_best_to_worst
FROM fsa_rated
GROUP BY local_authority_name
HAVING COUNT(*) >= 30
ORDER BY pct_five_star DESC;


-- 11.2 Top 5 and bottom 5 boroughs (copy into the report)
(SELECT 'best' AS grp, local_authority_name, ROUND(AVG(is_five_star::INT)*100,1) AS pct_five_star
 FROM fsa_rated GROUP BY 2 HAVING COUNT(*) >= 30 ORDER BY 3 DESC LIMIT 5)
UNION ALL
(SELECT 'worst', local_authority_name, ROUND(AVG(is_five_star::INT)*100,1)
 FROM fsa_rated GROUP BY 2 HAVING COUNT(*) >= 30 ORDER BY 3 ASC LIMIT 5);


-- 11.3 Business-type scorecard
SELECT
    business_type,
    COUNT(*)                                       AS rated_n,
    ROUND(AVG(is_five_star::INT) * 100, 1)         AS pct_five_star,
    ROUND(AVG(is_low_rated::INT) * 100, 1)         AS pct_low_rated,
    ROUND(AVG(rating_num), 2)                      AS avg_rating
FROM fsa_rated
GROUP BY business_type
HAVING COUNT(*) >= 30
ORDER BY pct_five_star DESC;


-- 11.4 Is the borough gap just a business-mix effect?
-- Compare each borough's rating with what we would EXPECT given its mix of business types.
WITH type_avg AS (
    SELECT business_type, AVG(rating_num) AS expected_rating
    FROM fsa_rated
    GROUP BY business_type
)
SELECT
    r.local_authority_name,
    COUNT(*)                                   AS rated_n,
    ROUND(AVG(r.rating_num), 2)                AS actual_avg,
    ROUND(AVG(t.expected_rating)::NUMERIC, 2)  AS expected_avg_given_mix,
    ROUND((AVG(r.rating_num) - AVG(t.expected_rating))::NUMERIC, 3) AS gap_vs_expected
FROM fsa_rated r
JOIN type_avg t USING (business_type)
GROUP BY r.local_authority_name
HAVING COUNT(*) >= 30
ORDER BY gap_vs_expected;
-- Reading: a negative gap = worse than expected even after accounting for business mix.


-- 11.5 Worst borough x business-type combinations (n >= 50 so it is not noise)
SELECT
    local_authority_name,
    business_type,
    COUNT(*)                                AS rated_n,
    ROUND(AVG(is_low_rated::INT) * 100, 1)  AS pct_low_rated
FROM fsa_rated
GROUP BY local_authority_name, business_type
HAVING COUNT(*) >= 50
ORDER BY pct_low_rated DESC
LIMIT 10;
