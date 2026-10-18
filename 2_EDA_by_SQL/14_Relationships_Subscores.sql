-- =================================
-- STEP 7a of the framework: RELATIONSHIPS between measures
-- Question: do the three sub-scores agree, and which one drives a poor rating?
-- =================================

-- 14.1 Correlation matrix (Pearson; -1 to 1). Scores: higher = worse, so expect negative vs rating.
SELECT
    ROUND(CORR(scores_hygiene, scores_structural)::NUMERIC, 2)                  AS hygiene_vs_structural,
    ROUND(CORR(scores_hygiene, scores_confidence_in_management)::NUMERIC, 2)    AS hygiene_vs_mgmt,
    ROUND(CORR(scores_structural, scores_confidence_in_management)::NUMERIC, 2) AS structural_vs_mgmt,
    ROUND(CORR(total_score, rating_num)::NUMERIC, 2)                            AS total_vs_rating,
    ROUND(CORR(scores_confidence_in_management, rating_num)::NUMERIC, 2)        AS mgmt_vs_rating,
    ROUND(CORR(scores_hygiene, rating_num)::NUMERIC, 2)                         AS hygiene_vs_rating
FROM fsa_rated;


-- 14.2 Average score at each rating level (shows how the rating is built)
SELECT
    rating_num,
    COUNT(*)                                  AS businesses,
    ROUND(AVG(scores_hygiene)::NUMERIC, 1)    AS avg_hygiene,
    ROUND(AVG(scores_structural)::NUMERIC, 1) AS avg_structural,
    ROUND(AVG(scores_confidence_in_management)::NUMERIC, 1) AS avg_mgmt,
    ROUND(AVG(total_score)::NUMERIC, 1)       AS avg_total
FROM fsa_rated
GROUP BY rating_num
ORDER BY rating_num DESC;


-- 14.3 What separates a low-rated (0-2) business from a 5-rated one?
SELECT
    ROUND(AVG(scores_hygiene)            FILTER (WHERE is_low_rated)::NUMERIC - AVG(scores_hygiene)            FILTER (WHERE is_five_star)::NUMERIC, 1) AS hygiene_gap,
    ROUND(AVG(scores_structural)         FILTER (WHERE is_low_rated)::NUMERIC - AVG(scores_structural)         FILTER (WHERE is_five_star)::NUMERIC, 1) AS structural_gap,
    ROUND(AVG(scores_confidence_in_management) FILTER (WHERE is_low_rated)::NUMERIC - AVG(scores_confidence_in_management) FILTER (WHERE is_five_star)::NUMERIC, 1) AS mgmt_gap
FROM fsa_rated;
-- Reading: the biggest gap is the sub-score that most separates failing from excellent businesses.
