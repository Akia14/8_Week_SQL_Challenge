------------------
--Case Study 2---
--Author: A'Kia Harris
--Date:May 11,2022
--Tool used: PostgresSQL
------------------
## Let's Investigate The Tables First

SELECT * FROM pizza_runner.runners
--There are 4 runners and this tables shows their registration date. Nothing to clean 

SELECT * FROM pizza_runner.customer_orders;
--Exclusions, extras, and order_time column must be cleaned 

SELECT * FROM pizza_runner.runner_orders;
--pickup time indlcudes the time and data in one column ; distance will be changed to miles and duration column will be cleaned up

SELECT * FROM pizza_runner.pizza_names;
--Only 2 names for ``pizza_id` meat lovers & vegetarians 

SELECT * FROM pizza_runner.pizza_recipes;
--shows the standar set of toppings for each pizza_names

SELECT * FROM pizza_runner.pizza_toppings; 
--Shows the topping names relevant to the ``topping_id``


-- A. Pizza Metrics

-- 1. What is the total amount each customer spent at the restaurant?

SELECT COUNT(*) FROM pizza_runner.customer_orders;

