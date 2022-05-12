# 🍕 Case Study #2: Pizza Runner

## Solution

View the complete syntax [here](https://github.com/Akia14/8_Week_SQL_Challenge/blob/main/Case%20Study%20%231/SQL%20syntax.sql)

***

### 1. What is the total amount each customer spent at the restaurant?

````sql
SELECT customer_id, SUM(price) AS Amount_Spent
FROM Dannys_Diner.sales AS s
JOIN Dannys_Diner.menu AS m
USING( product_id)
GROUP BY customer_id;
````

- Customer B has the most points with 940 
- Customer A has the second most points with 860
- Customer C has the least amount of points with 360 
***

SELECT * FROM pizza_runner.runners;
--There are 4 runners and this tables shows their registration date. Nothing to clean 
SELECT * FROM pizza_runner.customer_orders;
--exclusions, extras, and order_time column must be cleaned 
SELECT * FROM pizza_runner.runner_orders;
---pickup time indlcudes the time and data in one columb ; distance will be changed to miles and duration column will be cleaned up(See ERD for file types)
SELECT * FROM pizza_runner.pizza_names;
---Only 2 names for ``pizza_id` meat lovers & vegetarians 
SELECT * FROM pizza_runner.pizza_recipes;
---Will have to break up the toppings id numbers from ``toppings`` column maybe-----shows the standar set of toppings for each pizza_names
SELECT * FROM pizza_runner.pizza_toppings;
---Shows the topping names relevant to the ``topping_id``
