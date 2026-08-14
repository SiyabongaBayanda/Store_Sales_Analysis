/*
CLEANING DATA IN SQL QUERIES
*/
 -----------------------------------------------------------------------------------------------------

 SELECT *
 FROM StoreSalesProject.dbo.VrindaStore;
------------------------------------------------------------------------------------------------------

  -- Change W and M  to Women and Men in "Gender" field 

SELECT DISTINCT(Gender), COUNT(Gender) TotalNumber
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY Gender;

SELECT Gender, 
CASE WHEN Gender = 'W' THEN 'Women'
	 WHEN Gender = 'M' THEN 'Men'
	 ELSE Gender
END 
FROM StoreSalesProject.dbo.VrindaStore

UPDATE StoreSalesProject.dbo.VrindaStore
SET Gender = CASE WHEN Gender = 'W' THEN 'Women'
			 WHEN Gender = 'M' THEN 'Men'
			 ELSE Gender
END
----------------------------------------------------------------------------------------------------

-- Standardize Date Format (datetime to date)

ALTER TABLE StoreSalesProject.dbo.VrindaStore
ALTER COLUMN [Date] DATE;
---------------------------------------------------------------------------------------------------

-- Remove Duplicates 

WITH DuplicateRows AS(
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [Order ID], [Cust ID], Gender, Age, [Date], Category, Qty, Amount
           ORDER BY [index]
           ) AS RowNum
    FROM StoreSalesProject.dbo.VrindaStore
DELETE FROM DuplicateRows
WHERE RowNum > 1;
---------------------------------------------------------------------------------------------------
/*
DATA ANALYSIS USING SQL QEURIES
*/
---------------------------------------------------------------------------------------------------

-- Showing Comparison between Total Sales VS Total Orders by Month

SELECT 
    DATENAME(MONTH,[DATE])
FROM StoreSalesProject.dbo.VrindaStore

ALTER TABLE StoreSalesProject.dbo.VrindaStore
ADD [MONTH] VARCHAR(225)

UPDATE StoreSalesProject.dbo.VrindaStore
SET [MONTH] = DATENAME(MONTH,[DATE])
FROM StoreSalesProject.dbo.VrindaStore

SELECT 
    [MONTH],
    COUNT(DISTINCT [Order ID]) TotalOrders,
    SUM(Amount) TotalSales
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    [MONTH]
ORDER BY
-- sort months in the correct calendar order.
    CASE [MONTH]
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;
----------------------------------------------------------------------------------------------------

-- Showing Comparison between Age VS Gender of customers 

SELECT MIN(Age) FROM StoreSalesProject.dbo.VrindaStore YoungsetCustomer
SELECT MAX(Age) FROM StoreSalesProject.dbo.VrindaStore Oldestustomer

SELECT Age,
CASE WHEN Age < 30 THEN 'Young'
	 WHEN Age < 50 THEN 'Adult'
	 WHEN Age < 65 THEN 'Senior'
	 ELSE 'Pensioner'
END AgeGroup
FROM StoreSalesProject.dbo.VrindaStore

ALTER TABLE StoreSalesProject.dbo.VrindaStore
ADD AgeGroup VARCHAR(225)

UPDATE StoreSalesProject.dbo.VrindaStore
SET AgeGroup = CASE WHEN Age < 30 THEN 'Young'
	 WHEN Age < 50 THEN 'Adult'
	 WHEN Age < 65 THEN 'Senior'
	 ELSE 'Pensioner'
END 
FROM StoreSalesProject.dbo.VrindaStore


SELECT
    Gender,
    AgeGroup,
    --COUNT([Order ID]) TotalOrders,
    CAST(COUNT([Order ID]) * 100.0 /SUM(COUNT([Order ID])) OVER () AS DECIMAL(10,2)) OrderPercentage
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    Gender,
    AgeGroup
ORDER BY
    Gender,
    AgeGroup; 

-------------------------------------------------------------------------------------------------

-- Showing different Order Status 

SELECT 
    [Status],
    --COUNT([Order ID]) TotalOrder,
    CAST(COUNT([Order ID]) * 100.0 /SUM(COUNT([Order ID])) OVER () AS DECIMAL(10,2)) OrderPercentage
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    [Status]
ORDER BY 
    OrderPercentage DESC;
---------------------------------------------------------------------------------------------------

-- Showing Channel Contribution 

SELECT 
    Channel,
    --COUNT([Order ID]) TotalCount,
    CAST(COUNT([Order ID]) * 100.0 /SUM(COUNT([Order ID])) OVER () AS DECIMAL(10,2)) OrderPercentage
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    Channel
ORDER BY 
    OrderPercentage DESC;

---------------------------------------------------------------------------------------------------

-- Showing Top 10 States contributions by Sales

SELECT TOP 10
    [ship-state] State,
    SUM([Amount]) TotalSales
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    [ship-state]
ORDER BY
    TotalSales DESC;
 
--------------------------------------------------------------------------------------------------

-- Total Sales contributions by gender

SELECT
    Gender,
    SUM([Amount]) AS TotalSales,
    CAST(SUM([Amount]) * 100.0 /SUM(SUM([Amount])) OVER () AS DECIMAL(10,2)) SalesPercentage
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    Gender
ORDER BY
    SalesPercentage DESC;

--------------------------------------------------------------------------------------------------

-- Total Sales contributions by Category 

SELECT
    Category,
    SUM([Amount]) TotalSales
FROM StoreSalesProject.dbo.VrindaStore
GROUP BY
    [Category]
ORDER BY
    TotalSales DESC;

