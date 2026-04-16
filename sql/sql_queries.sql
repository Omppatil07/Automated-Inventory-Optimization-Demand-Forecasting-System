SQL QUERIES

Join All Tables
SELECT 
    s.order_ID,
    s.date,
    p.product_name,
    p.category,
    i.stock_available,
    s.units_sold,
    s.revenue
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
JOIN inventory i ON s.product_ID = i.product_ID;

Create a complete business view for analysis.


Total Sales per Product
SELECT 
    p.Product_Name,
    SUM(s.Units_Sold) AS Total_Sales
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC;

Insight:

Which products are selling the most?


Top 5 Best-Selling Products
SELECT 
    p.Product_Name,
    SUM(s.Units_Sold) AS Total_Sales
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Sales DESC
LIMIT 5;

Insight:

Focus on top-performing products (Pareto principle)


Low Stock Products
SELECT 
    p.Product_Name,
    i.Stock_Available
FROM inventory i
JOIN products p ON i.Product_ID = p.Product_ID
WHERE i.Stock_Available < 100
ORDER BY i.Stock_Available ASC;

Insights:

Which products are close to stockout?


Revenue by Category
SELECT 
    p.Category,
    SUM(s.Revenue) AS Total_Revenue
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;

Insights:

Which category generates most revenue?


Monthly Sales Trend
SELECT 
    MONTH(Date) AS Month,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Month
ORDER BY Month;

Insights:

How sales change over time?


Inventory Performance
SELECT 
    p.Product_Name,
    SUM(s.Units_Sold) AS Total_Sales,
    i.Stock_Available,
    (SUM(s.Units_Sold) / i.Stock_Available) AS Turnover
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
JOIN inventory i ON s.Product_ID = i.Product_ID
GROUP BY p.Product_Name, i.Stock_Available
ORDER BY Turnover DESC;

Insights:

Which products are selling fast and may run out soon?


Identify High-Risk Products
SELECT 
    p.Product_Name,
    i.Stock_Available,
    SUM(s.Units_Sold)/COUNT(DISTINCT s.Date) AS Daily_Avg_Sales,
    (i.Stock_Available / (SUM(s.Units_Sold)/COUNT(DISTINCT s.Date))) AS Days_of_Stock
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
JOIN inventory i ON s.Product_ID = i.Product_ID
GROUP BY p.Product_Name, i.Stock_Available
HAVING Days_of_Stock < 5
ORDER BY Days_of_Stock ASC;

Insights:

Which products will run out soon?


Reorder Suggestion Query
SELECT 
    p.Product_Name,
    i.Stock_Available,
    i.Lead_Time,
    (SUM(s.Units_Sold)/COUNT(DISTINCT s.Date)) AS Daily_Avg_Sales,
    ((SUM(s.Units_Sold)/COUNT(DISTINCT s.Date)) * i.Lead_Time + 20) AS Reorder_Point,
    CASE 
        WHEN i.Stock_Available < ((SUM(s.Units_Sold)/COUNT(DISTINCT s.Date)) * i.Lead_Time + 20)
        THEN 'Reorder Needed'
        ELSE 'Sufficient'
    END AS Reorder_Status
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
JOIN inventory i ON s.Product_ID = i.Product_ID
GROUP BY p.Product_Name, i.Stock_Available, i.Lead_Time;

Insights:

Automates inventory decisions.


Top Contributing Products to Revenue
SELECT 
    p.Product_Name,
    SUM(s.Revenue) AS Total_Revenue,
    ROUND(100 * SUM(s.Revenue) / 
        (SELECT SUM(Revenue) FROM sales), 2) AS Revenue_Percentage
FROM sales s
JOIN products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC;

Insights:

Which products drive most of the revenue?


Summary:

	I designed and executed advanced SQL queries to analyze sales and inventory data by integrating multiple tables using joins. I performed aggregations and implemented business logic to identify top-performing products, category-wise revenue, and monthly sales trends. Additionally, I built queries for inventory risk detection, reorder point calculation, and revenue contribution analysis, enabling automated, data-driven decisions for inventory optimization and demand planning.