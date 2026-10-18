-- =================================
-- Cumulative Analysis Over Time.
-- =================================


SELECT
    rating_months,
    number_rating,
    SUM(number_rating) OVER(ORDER BY rating_months) runnimg_total_ratings
FROM(
    SELECT 
        EXTRACT(MONTH from rating_date :: DATE) rating_months,
        COUNT(business_type_id) number_rating
    FROM fsa_rating
    WHERE EXTRACT(YEAR from rating_date :: DATE) IN (2025,2026)
    GROUP BY EXTRACT(MONTH from rating_date :: DATE)
    ORDER BY EXTRACT(MONTH from rating_date :: DATE)
    )