-- CUSTOMER PROFILING

SELECT *
FROM ecom;

-- COUNTRY AND GENDER DISTRIBUTION
-- customer count per country
SELECT Country, Count(*) as Total_Customer
FROM ecom
GROUP BY 1
ORDER BY 2 DESC;

-- gender split per country
SELECT
 Country,
 SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS MALE,
 SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS FEMALE
FROM ecom
WHERE Gender IS NOT NULL
GROUP BY 1;

-- AGE AND MEMBERSHIP ANALYSIS
-- average age and membership duration of customers by country
SELECT
 Country,
 COUNT(*) AS total_user,
 ROUND(AVG(Age),2) as average_age,
 ROUND(AVG(membership_years),2) as average_membership
FROM ecom
GROUP BY 1
ORDER BY 2 DESC;

-- age segmentation and membership duration analysis
SELECT
 CASE
  WHEN Age < 18 THEN 'Under 18'
  WHEN Age BETWEEN 18 AND 24 THEN 'Gen Z (18 - 24)'
  WHEN Age BETWEEN 25 AND 34 THEN 'Young Professionals (25 - 34)'
  WHEN Age BETWEEN 35 AND 44 THEN 'Mid-Career (35 - 44)'
  WHEN Age BETWEEN 45 AND 54 THEN 'Mature (45 - 54)'
  ELSE 'Senior (+55)'
  END as Age_Segment,
 COUNT(*) as Total_Customer,
 ROUND(AVG(membership_years),2) as average_membership
FROM ecom
WHERE Age IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- SIGN UP COHORT ANALYSIS
SELECT Signup_Quarter, 
 Count(*) as total_customer, 
 ROUND(AVG(membership_years),2) aecoms average_membership
FROM ecom
GROUP BY 1
ORDER BY 1;