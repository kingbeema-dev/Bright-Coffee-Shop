-- Bright Coffee Shop Data Analysis
--- Cleaning the data
-- 1) CHECKING THE IF ALL THE COLUMNS ARE IN THE CORRECT AND FIXING THE ONES THAT AREN'T
-- TYPE CASTING THE UNIT PRICE FROM INTEGER TO DECIMAL
    SELECT 
	    CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2)) AS Unit_Price
        FROM bright_coffee_shop_sales_1;

-- CHEKING FOR DUPLICATES
SELECT *,
	COUNT(*)
	FROM bright_coffee_shop_sales_1
	GROUP BY ALL
	HAVING COUNT(*) > 1;
    -- NO DUPLICATES

--- CHECKING FOR NULL VALUES

    SELECT * 
	FROM bright_coffee_shop_sales_1
    WHERE 
        transaction_id IS NULL OR 
        transaction_date IS NULL OR 
        transaction_time IS NULL OR 
        transaction_qty IS NULL OR 
        store_id IS NULL OR 
        store_location IS NULL OR 
        product_id IS NULL OR 
        unit_price IS NULL OR 
        product_category IS NULL OR 
        product_type IS NULL OR 
        product_detail IS NULL;

        -- NO NULL VALUES

-- DEALING WITH THE BUSINESS QUESTIONS: 

-- CALCULATING THE TOTAL REVENUE:
SELECT 
	SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue
    FROM bright_coffee_shop_sales_1;

--- CALCULATING TOTAL REVENUE PER PRODUCT:

SELECT 
	product_category,
    SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue
    FROM bright_coffee_shop_sales_1
    GROUP BY product_category
    ORDER BY Total_Revenue DESC;

    --- CALCULATING TOTAL REVENUE BY PRODUCT CATEGORY AND PRODUCT DETAIL
    SELECT
        product_category,
		product_detail,
		SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue

	FROM bright_coffee_shop_sales_1
	GROUP BY ALL
    ORDER BY Total_Revenue DESC;

--TOTAL REVENUE BY PRODUCT TYPE, CATEGORY AND DETAIL
SELECT
        product_category,
        product_type,
		product_detail,
		SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue

	FROM bright_coffee_shop_sales_1
	GROUP BY ALL
    ORDER BY Total_Revenue DESC;

-- TOTAL REVERNUE BASED ON TIME OF DAY
-- FIRST GET THE MINIMUM AND MAXIMUM TIMES
SELECT 
    MIN(transaction_time),
    MAX(transaction_time)
FROM bright_coffee_shop_sales_1;

-- MINIMUM TIME IS 06:00 AND MAXIMUM TIME IS 21:00
-- TIME INTERVALS ARE AS FOLLOWS:
-- 6am - 11:59 = MORNING
-- 12PM - 16:59 = AFTERNOON
-- 5PM - 19:59 = EVENING
-- After 8pm = Night



SELECT
    transaction_time,
    CASE
        WHEN transaction_time BETWEEN "06:00:00" AND "11:59:59" THEN "Morning"
        WHEN transaction_time BETWEEN "12:00:00" AND "16:59:59" THEN "Afternoon"
        WHEN transaction_time BETWEEN "17:00:00" AND "19:59:59" THEN "Evening"
        ELSE "Night"
    END AS time_bucket

FROM bright_coffee_shop_sales_1;


-- TOTAL REVENUE PRODUCT CATEGORY PER TIME BUCKET

SELECT
    product_category, 
    
    CASE
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "06:00:00" AND "11:59:59" THEN "Morning"
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "12:00:00" AND "16:59:59" THEN "Afternoon"
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "17:00:00" AND "19:59:59" THEN "Evening"
        ELSE "Night"
    END AS time_bucket,
    SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue
FROM bright_coffee_shop_sales_1
GROUP BY ALL
ORDER BY Total_Revenue DESC;

-- TOTAL REVENUE BY MONTH

SELECT 
    transaction_date, 
    MONTHNAME(transaction_date) AS month_name,
    DATE_FORMAT(transaction_date, "MMM-yyyy") AS month_id,
    DAYNAME(transaction_date) as day_of_week,
    DAYOFWEEK(transaction_date) AS day_number
FROM bright_coffee_shop_sales_1;

-- TOTAL REVENUE BY STORE LOCATION
SELECT
    store_location,
    SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue
FROM bright_coffee_shop_sales_1
GROUP BY ALL
ORDER BY Total_Revenue DESC;

-- ALL THE SYNTAX ABOVE IS CORRECT. NOW COMPILING THE FINAL TABLE

SELECT
    transaction_date,
    MONTHNAME(transaction_date) AS month_name,
    DATE_FORMAT(transaction_date, "MMM-yyyy") AS month_id,
    DAYNAME(transaction_date) as day_of_week,
    DAYOFWEEK(transaction_date) AS day_number,
    COUNT(product_id) AS trans_count,
    COUNT(product_id) AS products_sold,
    product_category,
    product_type,
    product_detail,
    store_location,
    CASE
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "06:00:00" AND "11:59:59" THEN "Morning"
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "12:00:00" AND "16:59:59" THEN "Afternoon"
        WHEN date_format(transaction_time, "HH:mm:ss") BETWEEN "17:00:00" AND "19:59:59" THEN "Evening"
        ELSE "Night"
    END AS time_bucket,
    SUM(transaction_qty * CAST (REPLACE (unit_price, ",", ".") AS DECIMAL(10,2))) AS Total_Revenue



FROM bright_coffee_shop_sales_1
GROUP BY ALL;