# Select dates and commodities for cities Quetta, Karachi, and Peshawar where price was less than or equal 50 PKR

select * from wfp_food_prices_pakistan;

select date, cmname AS comodity_name, price,mktname AS city_name
from wfp_food_prices_pakistan
Where mktname IN ('Quetta', 'Karachi', 'Peshawar') 
AND price <=50;

# Query to check number of observations against each market/city in PK

select mktname, mktid, country, count(*) AS num_observation
from wfp_food_prices_pakistan
group by mktname, mktid, country;

# Show number of distinct cities

SELECT count(DISTINCT mktname) as num_distinct_cities
FROM wfp_food_prices_pakistan;

# List down/show the names of cities in the table

Select Distinct mktname as names_of_cities
from wfp_food_prices_pakistan;

#List down/show the names of commodities in the table

select * from commodity;
select distinct cmname as names_of_commodities 
from commodity; 

select distinct cmname as names_of_commodities 
from wfp_food_prices_pakistan;

 # List Average Prices for Wheat flour - Retail in EACH city separately over the entire period.
 
SELECT mktname, AVG(price) AS avg_price
FROM wfp_food_prices_pakistan
WHERE cmname = 'Wheat flour - Retail'
GROUP BY mktname;

/* Calculate summary stats (avg price, max price) for each city separately for all cities except Karachi and sort 
alphabetically the city names, commodity names where commodity is Wheat (does not matter which one) with separate rows 
for each commodity*/ 

SELECT mktname, cmname,
    AVG(price) AS avg_price,
    max(price) AS max_price
FROM wfp_food_prices_pakistan
WHERE cmname LIKE 'Wheat%'
    AND mktname <> 'Karachi'
GROUP BY mktname, cmname
Order by  mktname, cmname;

# Calculate Avg_prices for each city for Wheat Retail and show only those avg_prices which are less than 30

SELECT mktname, AVG(price) AS avg_price
FROM wfp_food_prices_pakistan
WHERE cmname = 'Wheat - Retail'
GROUP BY mktname
HAVING AVG(price) < 30;

# Prepare a table where you categorize prices based on a logic (price < 30 is LOW, price > 250 is HIGH, 
# in between are FAIR). 

CREATE TABLE categorized_prices AS
SELECT cmname, mktname, price,
CASE WHEN price < 30 THEN 'LOW'
WHEN price > 250 THEN 'HIGH'
ELSE 'FAIR'
END AS price_category
FROM wfp_food_prices_pakistan;   #(Table Prepared)

select * from categorized_prices;

/* Create a query showing date, cmname, category, city, price, city_category where Logic for city category is: 
Karachi and Lahore are 'Big City', Multan and Peshawar are 'Medium-sized city', Quetta is 'Small City'*/

SELECT date, cmname, price, category, mktname,
CASE WHEN mktname IN ('Karachi', 'Lahore') THEN 'Big City'
WHEN mktname IN ('Multan', 'Peshawar') THEN 'Medium-sized City'
WHEN mktname = 'Quetta' THEN 'Small City'
ELSE 'Other'
END AS city_category
FROM wfp_food_prices_pakistan;

/* Create a query to show date, cmname, city, price. Create new column price_fairness through CASE showing price is
fair if less than 100, unfair if more than or equal to 100, if > 300 then 'Speculative'*/ 

select date, cmname, mktname, price, 
CASE When price < 100 then 'Fair'
When price >= 100 and price <= 300 then 'Unfair' 
when price > 300 then 'Speculative' 
End as Price_Fairness 
from wfp_food_prices_pakistan 
group by date, cmname, mktname, price; 

# Join the food prices and commodities table with a left join. 

SELECT * FROM wfp_food_prices_pakistan
LEFT JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;

# Join the food prices and commodities table with an inner join

SELECT * FROM wfp_food_prices_pakistan
INNER JOIN commodity ON wfp_food_prices_pakistan.cmname = commodity.cmname;