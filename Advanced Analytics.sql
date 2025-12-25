-- Churn Prediction
-- Engagement Score, Purchase Frequency Score, Support Dependency Score
SELECT Customer_ID,
round(
(
(Login_Frequency / MAX(Login_Frequency) OVER()) * 0.6 +
(Session_Duration_Avg / MAX(Session_Duration_Avg) OVER()) * 0.4
) * 100, 2
) as engagement_score,
round(
(
(Total_Purchases / MAX(Total_Purchases) OVER()) * 0.7 +
(Days_Since_Last_Purchase / MAX(Days_Since_Last_Purchase) OVER()) * 0.3
) * 100, 2
) as purchase_frequency_score,
round(
(Customer_Service_Calls / MAX(Customer_Service_Calls) OVER()) * 100, 2
) as support_dependency_score
FROM ecom;

-- segmenting
CREATE TABLE customers as 
SELECT Customer_ID, Age, Gender, Country, City, Churned
FROM ecom;

CREATE TABLE engagement AS
SELECT Customer_ID,
Login_Frequency, 
Session_Duration_Avg
FROM ecom;

CREATE TABLE purchase AS
SELECT Customer_ID,
Total_Purchases, 
Days_Since_Last_Purchase
FROM ecom;

CREATE TABLE support AS
SELECT Customer_ID,
Customer_Service_Calls
FROM ecom;

SELECT c.Customer_ID,
CASE 
WHEN e.Login_Frequency >= 20 AND e.Session_Duration_Avg >= 30 THEN 'High'
WHEN e.Login_Frequency BETWEEN 10 AND 19 THEN 'Medium'
ELSE 'Low'
END AS engagement_score,
CASE
WHEN p.Total_Purchases >= 20 AND p.Days_Since_Last_Purchase <= 30 THEN 'High'
WHEN p.Total_Purchases BETWEEN 10 AND 19 THEN 'Medium'
ELSE 'Low'
END AS purchase_score,
CASE
WHEN s.Customer_Service_Calls >= 10 THEN 'High'
WHEN s.Customer_Service_Calls BETWEEN 5 AND 9 THEN 'Medium'
ELSE 'Low' END AS support_dependency_score
FROM customers c
LEFT JOIN engagement e on c.Customer_ID = e.Customer_ID
LEFT JOIN purchase p on c.Customer_ID = p.Customer_ID
LEFT JOIN support s on c.Customer_ID = s.Customer_ID;

-- customer health score based on engagement, purchases, and recency
SELECT
Customer_ID,
CASE
WHEN Login_Frequency >= 20 AND Session_Duration_Avg >= 30 THEN 100
WHEN Login_Frequency >= 15 AND Session_Duration_Avg >= 20 THEN 80
WHEN Login_Frequency >= 10 THEN 60
ELSE 20
END * 0.4
+
CASE
WHEN Total_Purchases >= 20 THEN 100
WHEN Total_Purchases >= 15 THEN 80
WHEN Total_Purchases >= 10 THEN 60
WHEN Total_Purchases >=5 THEN 40
ELSE 20
END * 0.35
+
CASE
WHEN Days_Since_Last_Purchase <= 30 THEN 100
WHEN Days_Since_Last_Purchase <= 60 THEN 80
WHEN Days_Since_Last_Purchase <= 90 THEN 60
WHEN Days_Since_Last_Purchase <= 180 THEN 40
ELSE 20
END * 0.25 AS customer_health_score,
CASE
WHEN 
CASE
WHEN Login_Frequency >= 20 AND Session_Duration_Avg >= 30 THEN 100
WHEN Login_Frequency >= 15 AND Session_Duration_Avg >= 20 THEN 80
WHEN Login_Frequency >= 10 THEN 60
ELSE 20
END * 0.4
+
CASE
WHEN Total_Purchases >= 20 THEN 100
WHEN Total_Purchases >= 15 THEN 80
WHEN Total_Purchases >= 10 THEN 60
WHEN Total_Purchases >=5 THEN 40
ELSE 20
END * 0.35
+
CASE
WHEN Days_Since_Last_Purchase <= 30 THEN 100
WHEN Days_Since_Last_Purchase <= 60 THEN 80
WHEN Days_Since_Last_Purchase <= 90 THEN 60
WHEN Days_Since_Last_Purchase <= 180 THEN 40
ELSE 20
END * 0.25 >= 80 THEN 'Healthy'
WHEN 
CASE
WHEN Login_Frequency >= 20 AND Session_Duration_Avg >= 30 THEN 100
WHEN Login_Frequency >= 15 AND Session_Duration_Avg >= 20 THEN 80
WHEN Login_Frequency >= 10 THEN 60
ELSE 20
END * 0.4
+
CASE
WHEN Total_Purchases >= 20 THEN 100
WHEN Total_Purchases >= 15 THEN 80
WHEN Total_Purchases >= 10 THEN 60
WHEN Total_Purchases >=5 THEN 40
ELSE 20
END * 0.35
+
CASE
WHEN Days_Since_Last_Purchase <= 30 THEN 100
WHEN Days_Since_Last_Purchase <= 60 THEN 80
WHEN Days_Since_Last_Purchase <= 90 THEN 60
WHEN Days_Since_Last_Purchase <= 180 THEN 40
ELSE 20
END * 0.25 >= 60 THEN 'Stable'
WHEN 
CASE
WHEN Login_Frequency >= 20 AND Session_Duration_Avg >= 30 THEN 100
WHEN Login_Frequency >= 15 AND Session_Duration_Avg >= 20 THEN 80
WHEN Login_Frequency >= 10 THEN 60
ELSE 20
END * 0.4
+
CASE
WHEN Total_Purchases >= 20 THEN 100
WHEN Total_Purchases >= 15 THEN 80
WHEN Total_Purchases >= 10 THEN 60
WHEN Total_Purchases >=5 THEN 40
ELSE 20
END * 0.35
+
CASE
WHEN Days_Since_Last_Purchase <= 30 THEN 100
WHEN Days_Since_Last_Purchase <= 60 THEN 80
WHEN Days_Since_Last_Purchase <= 90 THEN 60
WHEN Days_Since_Last_Purchase <= 180 THEN 40
ELSE 20
END * 0.25 >= 40 THEN 'At Risk'
ELSE 'Critical'
END AS customer_health_status
FROM ecom;