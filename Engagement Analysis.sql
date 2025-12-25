-- ENGAGEMENT AND BEHAVIOR ANALYSIS

-- Do customers with higher login frequency spend more time per session?
SELECT
CASE 
  WHEN Login_Frequency < 10 THEN 'Low'
  WHEN Login_Frequency BETWEEN 10 AND 20 THEN 'Medium'
  ELSE 'High'
END AS Frequency,
ROUND(AVG(Session_Duration_Avg),2) AS Average_Duration
FROM ecom
WHERE Login_Frequency AND Session_Duration_Avg IS NOT NULL
GROUP BY 1
Order by 2 DESC;

-- How does mobile app usage impact session duration and pages per session?
SELECT
CASE 
  WHEN Mobile_App_Usage < 10 THEN 'Low'
  WHEN Mobile_App_Usage BETWEEN 10 AND 20 THEN 'Medium'
  ELSE 'High'
END AS Mobile_App_Use,
ROUND(AVG(Session_Duration_Avg),2) AS Average_Duration,
ROUND(AVG(Pages_Per_Session),2) AS Average_Pages
FROM ecom
WHERE Mobile_App_Usage AND Session_Duration_Avg AND Pages_Per_Session IS NOT NULL
GROUP BY 1
Order by 2 DESC;

-- Do customers with higher email open rates and social media engagement purchase more?
SELECT
 CASE 
  WHEN Email_Open_Rate < 20 THEN 'Low'
  WHEN Email_Open_Rate BETWEEN 20 AND 50 THEN 'Medium'
  ELSE 'High' END AS Email_Engagement,
 ROUND(AVG(Total_Purchases),2) as avg_purchases,
 ROUND(AVG(Average_Order_Value),2) as avg_order_value,
 ROUND(AVG(Lifetime_Value),2) as avg_lifetime_value
FROM ecom
WHERE Email_Open_Rate IS NOT NULL
GROUP BY 1
ORDER BY avg_lifetime_value DESC;

SELECT
 CASE 
  WHEN Social_Media_Engagement_Score < 20 THEN 'Low'
  WHEN Social_Media_Engagement_Score BETWEEN 20 AND 50 THEN 'Medium'
  ELSE 'High' END as Social_Media_Engagement,
 ROUND(AVG(Total_Purchases),2) as avg_purchases,
 ROUND(AVG(Average_Order_Value),2) as avg_order_value,
 ROUND(AVG(Lifetime_Value),2) as avg_lifetime_value
FROM ecom
WHERE Social_Media_Engagement_Score IS NOT NULL
GROUP BY Social_Media_Engagement
ORDER BY avg_lifetime_value DESC;