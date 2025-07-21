drop table if exists zepto;

Create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mpr NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice Numeric(8,2),
weightgrams INTEGER,
outofStock BOOLEAN,
quantity SMALLINT
);

SELECT COUNT(*) FROM zepto;--see the data import
-- look for null value

SELECT * FROM zepto 
where name IS NULL OR
mrp IS NULL OR
discountPercent IS NULL OR
availableQuantity  IS NULL OR
discountSellingPrice IS NULL OR
weightgrams IS NULL OR
outofStock IS NULL OR
quantity IS NULL;

Alter TABLE zepto Rename COLUMN mpr TO  mrp;

--- different product category 

Select DISTINCT category from zepto order by category;
--aggerate function
SELECT outofStock,AVG(sku_id) from zepto group by outofStock HAVING outofStock = false;

--- products name more than one 
SELECT  name, count(sku_id) as "number of skus"
from zepto Group by name
Having count(sku_id)>1
order by count(sku_id);

---data cleaning 

select name,mrp from zepto where mrp<= 0 or discountSellingPrice =0;

--delete this row
DELETE FROM  Zepto  where mrp<= 0 or discountSellingPrice =0;

-- CONVERT PAISE TO RUPEES
update zepto
set mrp = mrp/100.0, 
discountSellingPrice=discountSellingPrice/100.0;

select * from zepto;

--1. find the top 10 best-value products based om the discount price ?
select  DISTINCT name,mrp,discountpercent from zepto order by discountpercent DESC
limit 10;

select sku_id,avg(discountpercent) as "average_discountpercent" from zepto group by sku_id;
--2. what are the products with high mrp but out of stock

select DISTINCT  name,mrp,outofstock from zepto
WHERE outofstock = True 
order by mrp DESC
limit 10;
--3.calculate Estimated revenue for each category
select  category ,
sum(discountSellingPrice * availableQuantity) AS totalrevenue
from zepto 
group by category
order by totalrevenue;

--4. find all products where mrp is greter than 500 and discount is less than 10%
SELECT distinct name,mrp 
from zepto where mrp> 500 and 
discountPercent < 10;

--5.identity the top 5 categories offering the highest average discount percentage 

select DISTINCT category as distinctcategory 
,ROUND(avg(discountPercent)) as avgdiscount 
From zepto
group by category 
order by avgdiscount
limit 5;

--6. find the price per gram for products above 100 g and sort by best value

 SELECT DISTINCT name,weightgrams,discountSellingPrice, 
 ROUND(discountSellingPrice/weightgrams) as pricepergram
 FROM zepto
 WHERE weightgrams >=100
 order by pricepergram DESC;
 -- 7.group the products into categories like low,medium,bulk
     
select DISTINCT name,weightgrams,
case when weightgrams <1000 then 'low'
     when weightgrams <5000 then 'medium'
	  else  'bulk' end as weight_category
	  from zepto;
--8. which category contribute overall inventory weight per category
SELECT  distinct category,
sum( weightgrams * availableQuantity )/1000 as total_weight 
from zepto
group by category
order by total_weight;
