------------------
--Case Study 2---
--Author: A'Kia Harris
--Date:May 11,2022
--Tool used: PostgresSQL
------------------
### Lets Investigate The Tables Fist
-- Check out the tables metadata
SELECT
 table_name,
 column_name,
 data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders';

SELECT
 table_name,
 column_name,
 data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';


--Let's clean up the 2 main tables 

--customer_order table
SELECT * FROM pizza_runner.customer_orders; 

-- We will update the NULL values to show as blank to indicate no customers orders extras/exclusions
--Current "null" in table being interpreted as a string 

DROP TABLE IF EXISTS customer_orders_cleaned;
CREATE TEMP TABLE customer_orders_cleaned AS (
SELECT order_id, customer_id, pizza_id, 
CASE
  WHEN exclusions = '' THEN NULL 
  WHEN exclusions = 'null' THEN NULL 
  ELSE exclusions
  END AS exclusions, 
CASE 
  WHEN extras = '' THEN NULL
  WHEN extras = 'null' THEN NULL 
  ELSE extras
  END AS extras,
  order_time
FROM pizza_runner.customer_orders
);
SELECT * FROM customer_orders_cleaned;

--Now we'll clean the runner_orders table

SELECT * FROM pizza_runner.runner_orders;
-- We will clean up the ``picukup_time``, ``distance``, ``duration``, and ``cancellation`` table and change from VARCHAR to INT data type
-- null text will need to be NULL value

DROP TABLE IF EXISTS runner_orders_cleaned;
CREATE TEMP TABLE runner_orders_cleaned AS (
SELECT order_id, runner_id,
CASE WHEN pickup_time = 'null' THEN NULL
  ELSE pickup_time
  END AS pickup_time,
CASE WHEN distance = 'null' THEN NULL
  ELSE distance
  END AS distance,
CASE WHEN duration = 'null' THEN NULL
  ELSE duration
  END AS duration,
CASE WHEN cancellation IN ('null', '') THEN NULL
  ELSE cancellation
  END AS cancellation
FROM pizza_runner.runner_orders
);
SELECT * FROM runner_orders_cleaned



###Whats In the Tables
SELECT * FROM pizza_runner.runners
--There are 4 runners and this tables shows their registration date. Nothing to clean.

SELECT * FROM pizza_runner.customer_orders;
--Exclusions, extras, and order_time column must be cleaned 

SELECT * FROM pizza_runner.runner_orders;
--pickup time indlcudes the time and data in one column ; distance will be changed to miles and duration column will be cleaned up

SELECT * FROM pizza_runner.pizza_names;
--Only 2 names for ``pizza_id` meat lovers & vegetarians 

SELECT * FROM pizza_runner.pizza_recipes;
--shows the standard set of toppings for each pizza_names

SELECT * FROM pizza_runner.pizza_toppings; 
--Shows the topping names relevant to the ``topping_id``

###SOULUTIONS
-- A. Pizza Metrics

-- 1. What is the total amount each customer spent at the restaurant?

SELECT COUNT(*) FROM pizza_runner.customer_orders;

-- 2. How many unique customer orders were made?

SELECT COUNT(DISTINCT(order_id)) AS unique_customer_order FROM pizza_runner.customer_orders;

-- 3. How many successful orders were delivered by each runner?

SELECT * FROM runner_orders_cleaned;
SELECT runner_id, COUNT(order_id) AS Completed_Orders
FROM runner_orders_cleaned
WHERE cancellation IS NULL
GROUP BY 1
ORDER BY runner_id;

-- 4.How many of each type of pizza was delivered?
/* We need to join 3 tables 
1. customer_orders_cleaned as c (order_id column)
2. pizza_runner.pizza_names as p (pizza_id column)
3. runner_orders_cleaned as r (order_id column) */


SELECT p.pizza_name, COUNT(r.order_id) as Delivered_Pizza
FROM 
customer_orders_cleaned as c 
INNER JOIN 
pizza_runner.pizza_names as p ON c.pizza_id = p.pizza_id
INNER JOIN 
runner_orders_cleaned as r ON r.order_id = c.order_id
WHERE cancellation IS NULL
GROUP BY 1


--5.How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM customer_orders_cleaned
GROUP BY 1
ORDER BY 1;

--6. What was the maximum number of pizzas delivered in a single order?

WITH CTE_TEMP AS (

SELECT DISTINCT(c.customer_id) as customer_id, COUNT(r.order_id) as Delivered_Pizza
FROM 
customer_orders_cleaned as c 
INNER JOIN 
pizza_runner.pizza_names as p ON c.pizza_id = p.pizza_id
INNER JOIN 
runner_orders_cleaned as r ON r.order_id = c.order_id
WHERE cancellation IS NULL
GROUP BY 1
)
SELECT customer_id , MAX(Delivered_Pizza)  as Max_Pizzas_Delivered
FROM CTE_TEMP
GROUP BY 1
ORDER BY 2 desc
LIMIT 1


