
-- =========================================
-- ZEPTO DATA ANALYSIS PROJECT
-- Tool: PostgreSQL
-- =========================================

-- 1. Count total records
SELECT COUNT(*)
FROM zepto;

-- 2. View all records
SELECT *
FROM zepto;

-- 3. View first 5 records
SELECT *
FROM zepto
LIMIT 5;

-- 4. Identify NULL values
SELECT *
FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountpercent IS NULL
   OR availablequantity IS NULL
   OR discountedsellingprice IS NULL;

-- 5. View distinct product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- 6. Count in-stock and out-of-stock products
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

-- 7. Find products with zero MRP or selling price
SELECT *
FROM zepto
WHERE mrp = 0
   OR discountedsellingprice = 0;

-- 8. Remove products with zero prices
-- Run only if you intend to delete these records.
-- DELETE FROM zepto
-- WHERE mrp = 0
--    OR discountedsellingprice = 0;

-- 9. Convert prices from paise to rupees
-- Run only if prices have not already been converted.
-- UPDATE zepto
-- SET mrp = mrp / 100.0,
--     discountedsellingprice =
--         discountedsellingprice / 100.0;

-- 10. Count total rows
SELECT COUNT(*) AS total_rows
FROM zepto;

-- 11. Find duplicate product names and MRP
SELECT name, mrp, COUNT(*) AS duplicate_count
FROM zepto
GROUP BY name, mrp
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Q1. Top 10 products by discount percentage
SELECT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- Q2. High-MRP products that are out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE
  AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Estimated revenue by category
SELECT category,
       SUM(discountedsellingprice * availablequantity)
           AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Products with MRP above 500
-- and discount below 10%
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500
  AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

-- Q5. Top 5 categories by average discount
SELECT category,
       ROUND(AVG(discountpercent), 2)
           AS avg_discountpercent
FROM zepto
GROUP BY category
ORDER BY avg_discountpercent DESC
LIMIT 5;

-- Q6. Price per gram for products above 100 g
SELECT DISTINCT name, weightingms,
       discountedsellingprice,
       ROUND(
           discountedsellingprice / weightingms,
           2
       ) AS price_pergram
FROM zepto
WHERE weightingms > 100
ORDER BY price_pergram;

-- Q7. Classify products by weight
SELECT DISTINCT name, weightingms,
       CASE
           WHEN weightingms < 1000 THEN 'Low'
           WHEN weightingms < 1500 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8. Total inventory weight per category
SELECT category,
       SUM(weightingms * availablequantity)
           AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC;
