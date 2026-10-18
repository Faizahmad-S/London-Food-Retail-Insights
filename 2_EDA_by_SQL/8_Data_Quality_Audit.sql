-- =================================
-- STEP 3 of the EDA framework: DATA QUALITY AUDIT
-- Question: can I trust this table? What must I exclude before analysing?
-- Table: fsa_rating (one row = one food business)
-- =================================

-- 8.1 Row count and uniqueness (one row per business?)
SELECT
    COUNT(*)                   AS total_rows,
    COUNT(DISTINCT fhrsid)     AS unique_businesses,
    COUNT(*) - COUNT(DISTINCT fhrsid) AS duplicate_ids
FROM fsa_rating;


-- 8.2 Missing values in the columns that matter
SELECT
    COUNT(*) FILTER (WHERE rating_date IS NULL)               AS missing_rating_date,
    COUNT(*) FILTER (WHERE geocode_latitude IS NULL)          AS missing_geocode,
    COUNT(*) FILTER (WHERE scores_hygiene IS NULL)            AS missing_hygiene_score,
    COUNT(*) FILTER (WHERE scores_structural IS NULL)         AS missing_structural_score,
    COUNT(*) FILTER (WHERE scores_confidence_in_management IS NULL) AS missing_mgmt_score,
    COUNT(*) FILTER (WHERE post_code = 'Unknown')             AS unknown_postcode,
    COUNT(*) FILTER (WHERE address_line1 = 'Unknown')         AS unknown_address_line1
FROM fsa_rating;


-- 8.3 What does rating_value contain? (it is TEXT: numbers AND status words)
SELECT
    rating_value,
    COUNT(*) AS businesses,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM fsa_rating
GROUP BY rating_value
ORDER BY businesses DESC;
-- Finding: 0-5 are real ratings. Exempt / AwaitingInspection / AwaitingPublication are NOT ratings.


-- 8.4 Placeholder dates (1900/1901) - which rows are they?
SELECT
    rating_value,
    COUNT(*)           AS rows_with_placeholder_date,
    MIN(rating_date)   AS min_date,
    MAX(rating_date)   AS max_date
FROM fsa_rating
WHERE rating_date < DATE '1990-01-01'
GROUP BY rating_value
ORDER BY rows_with_placeholder_date DESC;
-- Finding: placeholder dates belong to unrated businesses only, so they must be
-- excluded from any date / change-over-time analysis (they distort the year chart).


-- 8.5 Are missing sub-scores explained by rating status?
SELECT
    rating_value,
    COUNT(*)                                          AS businesses,
    COUNT(*) FILTER (WHERE scores_hygiene IS NULL)    AS missing_scores,
    ROUND(COUNT(*) FILTER (WHERE scores_hygiene IS NULL) * 100.0 / COUNT(*), 1) AS pct_missing
FROM fsa_rating
GROUP BY rating_value
ORDER BY businesses DESC;
-- Finding: scores are missing for every unrated business (expected) plus a few
-- hundred rated ones (801 rows: keep the rating, total_score stays NULL).


-- 8.6 Impossible values: coordinates outside Greater London
SELECT COUNT(*) AS geocodes_outside_london
FROM fsa_rating
WHERE geocode_latitude IS NOT NULL
  AND NOT (geocode_latitude  BETWEEN 51.28 AND 51.70
       AND geocode_longitude BETWEEN -0.52 AND 0.34);


-- 8.7 Range check on scores (FSA scores are 0 to 30; lower = better)
SELECT
    MIN(scores_hygiene) AS min_hyg, MAX(scores_hygiene) AS max_hyg,
    MIN(scores_structural) AS min_str, MAX(scores_structural) AS max_str,
    MIN(scores_confidence_in_management) AS min_mgmt, MAX(scores_confidence_in_management) AS max_mgmt
FROM fsa_rating;


-- 8.8 Quality scorecard - one result to screenshot into the report
SELECT 'total_businesses'        AS check_name, COUNT(*)::TEXT AS result FROM fsa_rating
UNION ALL
SELECT 'rated_0_to_5',           COUNT(*)::TEXT FROM fsa_rating WHERE rating_value ~ '^[0-5]$'
UNION ALL
SELECT 'not_rated (exempt/awaiting)', COUNT(*)::TEXT FROM fsa_rating WHERE rating_value !~ '^[0-5]$'
UNION ALL
SELECT 'placeholder_dates',      COUNT(*)::TEXT FROM fsa_rating WHERE rating_date < DATE '1990-01-01'
UNION ALL
SELECT 'missing_geocode',        COUNT(*)::TEXT FROM fsa_rating WHERE geocode_latitude IS NULL
UNION ALL
SELECT 'rated_but_missing_scores', COUNT(*)::TEXT FROM fsa_rating WHERE rating_value ~ '^[0-5]$' AND scores_hygiene IS NULL;
