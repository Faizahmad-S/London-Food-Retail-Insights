-- =================================
-- Exploring the Dimensions columns
-- =================================
SELECT * FROM fsa_rating

-- Explore All Unique Authority_Name
SELECT DISTINCT local_authority_name
FROM fsa_rating

-- Explore All Unique Business_Type
SELECT DISTINCT business_type
FROM fsa_rating


-- Explore All Unique Rating_Value
SELECT DISTINCT rating_value
FROM fsa_rating