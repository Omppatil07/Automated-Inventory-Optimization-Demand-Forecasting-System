SQL QUERIES

Join All Tables
SELECT 
    s.order_ID,
    s.date,
    p.product_name,
    p.category,
    i.stock_available,
    s.unit_sold,
    s.revenue
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
JOIN inventory i ON s.product_ID = i.product_ID;

- Create a complete business view for analysis.


Total Sales per Product
SELECT 
    p.product_name,
    SUM(s.unit_sold) AS Total_Sales
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
GROUP BY p.product_name
ORDER BY Total_Sales DESC;

Insight:
- Which products are selling the most?


Top 5 Best-Selling Products
SELECT 
    p.product_name,
    SUM(s.unit_sold) AS Total_Sales
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
GROUP BY p.product_name
ORDER BY Total_Sales DESC
LIMIT 5;

Insight:
- Focus on top-performing products (Pareto principle)


Low Stock Products
SELECT 
    p.product_name,
    i.stock_available
FROM inventory i
JOIN products p ON i.product_ID = p.product_ID
WHERE i.stock_available < 100
ORDER BY i.stock_available ASC;

Insights:
- Which products are close to stockout?


Revenue by Category
SELECT 
    p.category,
    SUM(s.revenue) AS Total_Revenue
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
GROUP BY p.category
ORDER BY Total_Revenue DESC;

Insights:
- Which category generates most revenue?


Monthly Sales Trend
SELECT 
    MONTH(date) AS Month,
    SUM(revenue) AS Total_Revenue
FROM sales
GROUP BY Month
ORDER BY Month;

Insights:
- How sales change over time?


Inventory Performance
SELECT 
    p.product_name,
    SUM(s.unit_sold) AS Total_Sales,
    i.stock_available,
    (SUM(s.unit_sold) / i.stock_available) AS Turnover
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
JOIN inventory i ON s.product_ID = i.product_ID
GROUP BY p.product_name, i.stock_available
ORDER BY Turnover DESC;

Insights:
- Which products are selling fast and may run out soon?


Identify High-Risk Products
SELECT 
    p.product_name,
    i.stock_available,
    SUM(s.unit_sold)/COUNT(DISTINCT s.date) AS Daily_Avg_Sales,
    (i.stock_available / (SUM(s.unit_sold)/COUNT(DISTINCT s.date))) AS Days_of_Stock
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
JOIN inventory i ON s.product_ID = i.product_ID
GROUP BY p.product_name, i.stock_available
HAVING Days_of_Stock < 5
ORDER BY Days_of_Stock ASC;

Insights:
- Which products will run out soon?


Reorder Suggestion Query
SELECT 
    p.product_name,
    i.stock_available,
    i.lead_time,
    (SUM(s.unit_sold)/COUNT(DISTINCT s.date)) AS Daily_Avg_Sales,
    ((SUM(s.unit_sold)/COUNT(DISTINCT s.date)) * i.lead_time + 20) AS Reorder_Point,
    CASE 
        WHEN i.stock_available < ((SUM(s.units_sold)/COUNT(DISTINCT s.date)) * i.lead_time + 20)
        THEN 'Reorder Needed'
        ELSE 'Sufficient'
    END AS Reorder_Status
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
JOIN inventory i ON s.product_ID = i.product_ID
GROUP BY p.product_name, i.stock_available, i.lead_time;

Insights:
- Automates inventory decisions.


Top Contributing Products to Revenue
SELECT 
    p.product_name,
    SUM(s.revenue) AS Total_Revenue,
    ROUND(100 * SUM(s.revenue) / 
        (SELECT SUM(revenue) FROM sales), 2) AS Revenue_Percentage
FROM sales s
JOIN products p ON s.product_ID = p.product_ID
GROUP BY p.product_name
ORDER BY Total_Revenue DESC;

Insights:
- Which products drive most of the revenue?


Summary:

	I designed and executed advanced SQL queries to analyze sales and inventory data by integrating multiple tables using joins. I performed aggregations and implemented business logic to identify top-performing products, category-wise revenue, and monthly sales trends. Additionally, I built queries for inventory risk detection, reorder point calculation, and revenue contribution analysis, enabling automated, data-driven decisions for inventory optimization and demand planning.
