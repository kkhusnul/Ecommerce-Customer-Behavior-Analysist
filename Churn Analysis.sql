-- CHURN ANALYSIS

-- What percentage of customers have churned?
SELECT 
  CASE
   WHEN Churned = 0 THEN 'Active' 
   ELSE 'Churned' END as customer_status,
  Count(*) as total_customer,
  ROUND(
   COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () 
   , 2) as percentage
FROM ecom
WHERE Churned IS NOT NULL
GROUP BY 1;

-- Which countries have the highest churn rate?
SELECT
 Country,
 COUNT(*) AS total_customer,
 SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_customer,
 ROUND(SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*),2) as churned_percentage
FROM ecom
GROUP BY 1
ORDER BY 4 DESC;

-- What behaviors are common among churned customers?
SELECT
 CASE 
  WHEN Churned = 1 THEN 'CHURNED'
  ELSE 'ACTIVE'
  END AS customer_status,
 Count(*) as total_customer,
 ROUND(avg(Login_Frequency),2) as avg_login_frequency,
 ROUND(avg(Days_Since_Last_Purchase),2) as avg_last_purchase_duration,
 ROUND(avg(Session_Duration_Avg),2) as avg_session_duration,
 ROUND(avg(Customer_Service_Calls),2) as avg_cs_calls
FROM ecom
WHERE Churned IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Does higher customer service calls correlate with churn?
SELECT
 CASE 
  WHEN Customer_Service_Calls < 5 THEN 'Low'
  WHEN Customer_Service_Calls BETWEEN 5 AND 10 THEN 'Medium'
  ELSE 'High' END AS cs_calls_frequency,
 Count(*) as total_customer,
 SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) as churned_customer,
 ROUND(SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*),2) as churned_percentage
FROM ecom
WHERE Customer_Service_Calls IS NOT NULL
GROUP BY 1
ORDER BY 4 DESC;

-- Is high credit balance associated with churn risk?
SELECT
CASE 
WHEN Credit_Balance < 1000 THEN 'Low'
WHEN Credit_Balance BETWEEN 1000 AND 2500 THEN 'Medium'
ELSE 'High' END AS credit_balance_risk,
Count(*) as total_customer,
SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) as churned_customer,
ROUND(SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*),2) as churned_percentage
FROM ecom
WHERE Credit_Balance IS NOT NULL
GROUP BY 1
ORDER BY 4 DESC;