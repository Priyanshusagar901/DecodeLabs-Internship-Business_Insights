/*
=========================================================
E-Commerce Business Insights Using SQL
Author: Priyanshu Sagar
Project: SQL Business Insights Analysis

Description:
This project analyzes e-commerce sales data using SQL
to generate business insights related to revenue,
customer behavior, product performance, marketing
channels, and customer retention.

Skills Demonstrated:
- SQL Aggregations
- GROUP BY
- CASE Statements
- Subqueries
- KPI Analysis
- Revenue Analytics
- Customer Analytics
=========================================================
*/
-- =====================================================
-- 0. DATA OVERVIEW
-- Objective: Review the dataset and understand its structure.
-- Business Value: Provides an initial understanding of the available data before analysis.
-- =====================================================
SELECT * FROM tables;

--  =====================================================
-- 1. PRODUCT-WISE SALES ANALYSIS
-- Objective: Identify top-performing products based on revenue and quantity sold.
-- Business Value: Helps understand which products contribute most to sales.
-- =====================================================
SELECT Product,ROUND(SUM(TotalPrice),2) AS Revenue,SUM(Quantity) AS Quantity_Sell
FROM tables
GROUP BY Product
ORDER BY Revenue DESC
LIMIT 5;

-- =====================================================
-- 2. REFERRAL SOURCE PERFORMANCE
-- Objective: Analyze which referral sources generate the most customers and revenue.
-- Business Value: Helps evaluate marketing channel effectiveness.
-- =====================================================
SELECT ReferralSource,COUNT(DISTINCT CustomerID) AS Total_Customer,ROUND(SUM(TotalPrice),2) AS Revenue
FROM tables
GROUP BY ReferralSource
ORDER BY Total_Customer DESC,Revenue DESC;

-- =====================================================
-- 3. ORDER STATUS DISTRIBUTION
-- Objective: Examine the distribution of shipped, cancelled, and returned orders.
-- Business Value: Helps assess operational efficiency and fulfillment performance.
-- =====================================================
SELECT OrderStatus,COUNT(*) AS Total_Orders,
ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM tables),2) AS Percentage
FROM tables
GROUP BY OrderStatus;

-- =====================================================
-- 4. PAYMENT METHOD ANALYSIS
-- Objective: Analyze customer payment preferences.
-- Business Value: Helps optimize payment options and customer experience.
-- =====================================================
SELECT PaymentMethod,ROUND(SUM(TotalPrice),2) AS Revenue,COUNT(PaymentMethod) AS Count_Of_Methods
FROM tables
GROUP BY PaymentMethod
ORDER BY Revenue DESC;

-- =====================================================
-- 5. MOST RETURNED PRODUCT
-- Objective: Identify the product with the highest number of returns.
-- Business Value: Helps detect quality or customer satisfaction issues.
-- =====================================================
SELECT Product,COUNT(Product) AS Returned_Product_Count
FROM tables
WHERE OrderStatus='Returned'
GROUP BY Product
ORDER BY Returned_Product_Count DESC
LIMIT 1;

-- =====================================================
-- 6. AVERAGE ORDER VALUE (AOV)
-- Objective: Calculate average revenue generated per order.
-- Business Value: Measures customer spending behavior and revenue efficiency.
-- =====================================================
SELECT ROUND(SUM(TotalPrice)/COUNT(DISTINCT OrderID),2) AS Average_Order_Value
FROM tables;

-- =====================================================
-- 7. MONTHLY REVENUE TREND
-- Objective: Analyze revenue performance across months.
-- Business Value: Helps identify seasonal trends and demand patterns.
-- =====================================================
SELECT MONTHNAME(Date) AS Months,ROUND(SUM(TotalPrice),2) AS Revenue
FROM tables
GROUP BY MONTH(Date),Months
ORDER BY MONTH(Date);

-- =====================================================
-- 8. REVENUE AT RISK
-- Objective: Calculate revenue impacted by returned and cancelled orders.
-- Business Value: Highlights potential revenue loss and operational issues.
-- =====================================================
SELECT ROUND(
SUM(CASE WHEN OrderStatus IN('Cancelled','Returned')
THEN TotalPrice ELSE 0 END),2) AS Revenue_At_Risk
FROM tables;

-- =====================================================
-- 9. REPEAT CUSTOMER RATE
-- Objective: Measure the percentage of customers who made multiple purchases.
-- Business Value: Evaluates customer loyalty and retention performance.
-- =====================================================
SELECT ROUND(
COUNT(DISTINCT CASE WHEN Order_Count>1 THEN CustomerID END)*100.0/
COUNT(DISTINCT CustomerID),2) AS Repeat_Customer_Rate
FROM(
SELECT CustomerID,COUNT(*) AS Order_Count
FROM tables
GROUP BY CustomerID
)t;

-- =====================================================
-- 10. TOP 5 CUSTOMERS BY REVENUE
-- Objective: Identify customers contributing the highest revenue.
-- Business Value: Supports customer retention and loyalty strategies.
-- =====================================================
SELECT CustomerID,ROUND(SUM(TotalPrice),2) AS Revenue
FROM tables
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 5;

-- =====================================================
-- 11. TOTAL REVENUE
-- Objective: Calculate the total revenue generated from all orders.
-- Business Value: Serves as a key performance indicator for measuring overall business performance.
-- =====================================================
SELECT ROUND(SUM(TotalPrice),2) AS Total_Revenue
FROM tables;