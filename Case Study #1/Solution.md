# 🍜 Case Study #1: Danny's Diner

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

#### Steps:
- Use **SUM** and **GROUP BY** to find out ```total_sales``` contributed by each customer.
- Use **JOIN** to merge ```sales``` and ```menu``` tables as ```product_id``` are from both tables.


#### Answer:

| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.
***


### 2.How many days has each customer visited the restaurant?
````sql
SELECT customer_id, COUNT(DISTINCT(order_date)) AS Days_Visited
FROM Dannys_Diner.sales
GROUP BY customer_id
````

#### Steps:
- Use **COUNT**, **DISTINCT**, and **GROUP BY** to find out ```Days_Visited``` by each customer.

#### Answer:

| customer_id | Days_Visited|
| ----------- | ----------- |
| A           | 4           |
| B           | 6           |
| C           | 2           |

- Customer A visited 4 days
- Customer B visited 6 days
- Customer C visited 2 days
***

### 3.What was the first item from the menu purchased by each customer?
```sql
SELECT customer_id, order_date, product_name
FROM
(
    SELECT customer_id, product_name, order_date,
    DENSE_RANK() OVER(PARTITION BY(customer_id) 
    ORDER BY(order_date)) AS first_order
    FROM Dannys_Diner.sales 
    JOIN Dannys_Diner.menu USING (product_id)
)
WHERE first_order = 1
GROUP BY customer_id, order_date, product_name 
ORDER BY customer_id
```
### Steps:
- **DENSE_RANK** to rank columns based on ```Order_Date``` Since there is no time stamp, **DENSE_RANK** ensures all items purchased on same day are accounted for.
- **OVER(PARTITION BY()** used to rank rows based on customer_id and **ORDER BY** ``Order_Date``
- Filtered data to where only the first orders are shown using the **WHERE** statement 

### Answer:
|customer_id | order_date | product_name |
|------------|------------|--------------|
|A           |2021-01-01  | curry        |
|A           |2021-01-01  | sushi        |
|B           |2021-01-01  | curry        |
|C           |2021-01-01  | ramen        |

***



### 4.What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT product_name, COUNT(product_name) AS Times_purchased,SUM(price) AS Revenue_From_Item
FROM Dannys_Diner.sales JOIN Dannys_Diner.menu USING(product_id)
GROUP BY product_name 
ORDER BY Times_purchased DESC
```
###Steps:
- used **COUNT()*** to find the total time that each menu item appeared in the dataset
- used **SUM()** on ``price`` to find the Total Revenue each item produced
- used **ORDER BY()** in descending order to bring the most purchased product to the top
- 
### Answer:
|product_name | Times_Purchased | Revenue_From_Item |
|-------------|-----------------|-------------------|
|Ramen        | 8               | 96                |
|Curry        | 4               | 60                |
|Sushi        | 3               | 30                |
***





### 5.Which item was the most popular for each customer?
SELECT customer_id, product_name, order_count
FROM
    (
    SELECT customer_id, product_name, COUNT(product_name) AS order_count,
    DENSE_RANK() OVER(PARTITION BY(customer_id)
    ORDER BY COUNT(product_name)) AS popular_item
    FROM Dannys_Diner.sales JOIN Dannys_Diner.menu USING(product_id)
    GROUP BY customer_id, product_name
    )
GROUP BY customer_id, product_name, order_count 
ORDER BY customer_id, order_count DESC


## Used DENSE_RANK() to rank the Order_Count based on amount of times each product was purchased by each customer
#Generated most popular product by using ORDER BY() DESC

### 6.Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name, MIN(order_date) AS First_Order_As_Member
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date >= join_date
GROUP BY customer_id, product_name
ORDER BY First_Order_As_Member
# Used MIN() function to find the earliest order date and WHERE() to filter out the dates to only include when customer became a member 
-- HOW TO HAVE DATA SHOW ONLY 1 OPTION / ONLY THE FIRST RESULT--
SELECT customer_id, order_date, product_name
FROM
    (
   SELECT customer_id, join_date, order_date, product_id,
      DENSE_RANK() OVER(PARTITION BY customer_id
      ORDER BY order_date) AS rank
   FROM `dataworks2014.Dannys_Diner.sales` AS s
   JOIN `dataworks2014.Dannys_Diner.members` AS m
      USING(customer_id)
   WHERE order_date >= join_date
    )
FULL JOIN `dataworks2014.Dannys_Diner.menu` 
    USING(product_id)
WHERE rank = 1
##Dupe of above just a diffrent option 


### 7.Which item was purchased just before the customer became a member?

SELECT customer_id, product_name, MAX(order_date) AS Last_Regular_Order
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date <= join_date
GROUP BY customer_id, product_name
ORDER BY Last_Regular_Order
##USED max() to get the oldest order before they customer becme a member 

###Option #2 using dense_rank that i need to understand further 
SELECT customer_id, MAX(order_date) AS DATE_ORDERED_BEFORE_MEMBER, join_date,product_name
FROM
    (
    SELECT customer_id, order_date,join_date,product_name,
        DENSE_RANK() OVER(PARTITION BY customer_id
        ORDER BY order_date DESC) AS ranks
    FROM Dannys_Diner.members JOIN Dannys_Diner.sales USING(customer_id)
    JOIN `dataworks2014.Dannys_Diner.menu`USING(product_id)
    )
WHERE ranks = 1
GROUP BY customer_id, order_date, join_date,product_name


### 8.What is the total items and amount spent for each member before they became a member?
SELECT customer_id, COUNT(product_name) AS Total_Items, SUM(price) AS Total_Spent
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY Total_Spent DESC
##FILTER order_dae, and use SUM to find prrice total 


### 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id, 
    SUM(
        CASE product_name
        WHEN 'sushi' THEN price * 20 
        ELSE price * 10 
        END )
         AS Customer_Points
FROM `dataworks2014.Dannys_Diner.sales` 
    JOIN `dataworks2014.Dannys_Diner.menu` USING(product_id)
GROUP BY customer_id
## used CASE() as and IF THEN function to set rules for customer points 
#Added these to get customer point total

### 10..In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH CTE_Dates AS
    ( SELECT*,
        DATE_ADD(DATE (join_date), INTERVAL 6 DAY) AS End_Special,
        Last_DAY(DATE('2021-01-31')) AS Last_Day_Special
        FROM `dataworks2014.Dannys_Diner.members`
    )
SELECT customer_id, join_date, End_Special, Last_Day_Special,
    SUM(CASE
        WHEN product_name = 'sushi' THEN price * 20
        WHEN order_date BETWEEN join_date AND End_Special
        THEN price * 20 
        ELSE price * 10
        END
        ) AS Total_Points
FROM CTE_Dates
JOIN `dataworks2014.Dannys_Diner.sales` USING(customer_id)
JOIN `dataworks2014.Dannys_Diner.menu` USING(product_id)
WHERE order_date <= Last_Day_Special
GROUP BY customer_id,join_date, End_Special, Last_Day_Special

##Created a tempoary table using WITH() where we were able to find the 7 day special for each customer
# From the temporary table we used SUM() and CASE() to create a condtion where only order within the first week special reiceved 2x points
# Also ensured that throughout the first month sushi still recieved 2x points 


### Bonus.01 
--JOIN ALL THE THINGS--
SELECT customer_id, product_name, price,
CASE 
    WHEN order_date >= join_date THEN 'Y'
    WHEN order_date < join_date THEN 'N'
    WHEN join_date IS NULL THEN 'N'
    END AS members
FROM Dannys_Diner.members FULL JOIN Dannys_Diner.sales USING(customer_id)
   JOIN Dannys_Diner.menu USING(product_id)
## To create the table we created a full join to combine all data from all three tables togehter
## Then utilized the CASE statement to set rules to identfy each customer as a member or not based
#on when they ordered and became a member. 


### Bonus.02 
--Bonus.2 Rank All The Things--
WITH CTE_members AS
    (
    SELECT customer_id,order_date, product_name, price,
        CASE 
            WHEN order_date >= join_date THEN 'Y'
            WHEN order_date < join_date THEN 'N'
            WHEN join_date IS NULL THEN 'N'
            END AS member
FROM Dannys_Diner.members FULL JOIN Dannys_Diner.sales USING(customer_id)
   JOIN Dannys_Diner.menu USING(product_id)
   ORDER BY customer_id
   )

SELECT *,
    CASE WHEN member = 'N' THEN null
        ELSE 
           DENSE_RANK() OVER(PARTITION BY customer_id, member
                    ORDER BY order_date)
    END AS Ranks
FROM CTE_members 
ORDER BY customer_id, order_date
##Created a view from preivus table stating y/n member and create a case statement to satisfy customer wants of ranking the orders based on order date
