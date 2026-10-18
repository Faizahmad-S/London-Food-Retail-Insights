-- =================================
-- Build ONE clean analysis layer so every later query uses the same rules
-- fsa_rating = raw cleaned table | fsa_rated = only businesses with a real 0-5 rating
-- =================================

DROP VIEW IF EXISTS fsa_rated;

CREATE VIEW fsa_rated AS
SELECT
    f.*,
    rating_value::INT AS rating_num,
    scores_hygiene + scores_structural + scores_confidence_in_management AS total_score,  -- FSA scoring: LOWER = BETTER
    (rating_value::INT = 5) AS is_five_star,
    (rating_value::INT <= 2) AS is_low_rated        -- 0-2 = improvement necessary or worse
FROM fsa_rating f
WHERE rating_value ~ '^[0-5]$';

-- Check
SELECT COUNT(*) AS rated_businesses FROM fsa_rated;
