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

- Customer A purchased Sushi and Curry first
- Customer B purchased curry first
- Customer C purchased ramen first
***


### 4.What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT product_name, COUNT(product_name) AS Times_purchased,SUM(price) AS Revenue_From_Item
FROM Dannys_Diner.sales JOIN Dannys_Diner.menu USING(product_id)
GROUP BY product_name 
ORDER BY Times_purchased DESC
```
### Steps:
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

- Ramen was the most popular item and was purhcased 8 times
- Curry was the secon most popular item and was purchased 4 times
- Sushi was the least purchased item and was only purchased 3 times 

***


### 5.Which item was the most popular for each customer?

```sql
WITH CTE_RANKS AS
    (
    SELECT customer_id, product_name, COUNT(product_name) AS order_count,
    DENSE_RANK() OVER(PARTITION BY(customer_id)
    ORDER BY COUNT(product_name) DESC) AS Ranking 
    FROM Dannys_Diner.sales JOIN Dannys_Diner.menu USING(product_id)
    GROUP BY customer_id, product_name
    )
SELECT * 
FROM CTE_RANKS
WHERE Ranking = 1
ORDER BY customer_id
```
### Steps:

- Used **DENSE_RANK()** to rank the ``Order_Count`` based on amount of times each product was purchased by each customer
- Generated most popular product by using **ORDER BY() DESC** and filtered most popular products with **WHERE = 1**

### Answer:
| customer_id | product_name | order_count | Ranking  |
| ----------- | ------------ |-------------|----------|
| A           | ramen        |  3          | 1        |
| B           | sushi        |  2          | 1        |
| B           | curry        |  2          | 1        |
| B           | ramen        |  2          | 1        |
| C           | ramen        |  3          | 1        |

- Customer A and C's most purchased item was Ramen 
- Customer B purchased all items sushi, curry, and ramen equally

***

### 6.Which item was purchased first by the customer after they became a member?

```sql
SELECT customer_id, order_date, product_name
FROM
    (
   SELECT customer_id, join_date, order_date, product_id,
      DENSE_RANK() OVER(PARTITION BY customer_id
      ORDER BY order_date) AS rank
   FROM Dannys_Diner.sales
   JOIN Dannys_Diner.members
      USING(customer_id)
   WHERE order_date >= join_date
    )
FULL JOIN `dataworks2014.Dannys_Diner.menu` 
    USING(product_id)
WHERE rank = 1
```
## Steps:
- Used **MIN()** to find the earliest ``order date`` and **WHERE()** to filter out the dates to only include when customer became a member
- Used **DENSE_RANK() OVER(PARTITION BY(** used to rank by ``order_date`` and group by ``customer_id`` 

## Answer:
| customer_id | order_date | product_name  | 
| ----------- | ------------ |-------------|
| B           | 2021-01-11   |  sushi      | 
| A           | 2021-01-07   |  curry      |

- Customer A first purchase as a member was curry on 2021-01-07
- Customer B first purchase as a member was sushi on 2021-01-11
***


### 7.Which item was purchased just before the customer became a member?
```sql
WITH CTE_Ranks AS (
SELECT customer_id, product_name, MAX(order_date) AS Last_Regular_Order, 
    DENSE_RANK() OVER(PARTITION BY customer_id
        ORDER BY MAX(order_date)) AS Ranks
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date < join_date
GROUP BY customer_id, product_name
)
SELECT * 
FROM CTE_Ranks
WHERE Ranks = 1

```

### Steps:
- Used **MAX()** to retrieve the last order made before each customer became a memeber 
- **WHERE()** used to filter the orders before customer became a member 
- 
### Answer:
| customer_id | Last_Regular_order  | product_name |
| ----------- | ---------- |----------  |
| A           | 2021-01-01 |  sushi        |
| A           | 2021-01-01 |  curry        |
| B           | 2021-01-04 |  sushi        |

- Customer A's last order before becoming a member was on 2021-01-01 and they purchased sushi & curry 
- Customer B's last order before becoming a member was on 2021-01-04 and they purhcased sushi 
***


### 8.What is the total items and amount spent for each member before they became a member?

```sql
SELECT customer_id, COUNT(product_name) AS Total_Items, SUM(price) AS Total_Spent
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY Total_Spent DESC
```
### Steps:
- Used **WHERE()** to filter the ``order_date`` to only include orders before customers became members 
- Used **SUM()** to calculate the ``Total_Amount_Spent``


### Answer:
| customer_id | Total_Itms | total_sales |
| ----------- | ---------- |----------  |
| B           | 3 |  40       |
| A           | 2 |  25       |

Before becoming members,
- Customer A spent $ 25 on 2 items
- Customer B spent $40 on 3 items
***


### 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT customer_id, 
    SUM(
        CASE product_name
        WHEN 'sushi' THEN price * 20 
        ELSE price * 10 
        END )
         AS Customer_Points
FROM Dannys_Diner.sales 
    JOIN Dannys_Diner.menu USING(product_id)
GROUP BY customer_id
```

## Steps:
- Used **CASE()** as to set rules for customer points based on the ``product_name``
- Used **SUM()** to get the total of customer points 

## Answer:
|Customer_id  |Customer_Points|
|-------------|---------------|
|A   |860  |
|B   |940  |
|C   |360  |

- Customer B has the most points with 940 
- Customer A has the second most points with 860
- Customer C has the least amount of points with 360 
***

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
``sql
WITH CTE_Dates AS
    ( SELECT*,
        DATE_ADD(DATE (join_date), INTERVAL 6 DAY) AS End_First_Week_Special,
        Last_DAY(DATE('2021-01-31')) AS Last_Day
        FROM Dannys_Diner.members
    )
SELECT customer_id, join_date, End_First_Week_Special, Last_Day,
    SUM(CASE
        WHEN product_name = 'sushi' THEN price * 20
        WHEN order_date BETWEEN join_date AND End_First_WeeK_Special
        THEN price * 20 
        ELSE price * 10
        END
        ) AS Total_Points
FROM CTE_Dates
JOIN Dannys_Diner.sales USING(customer_id)
JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date <= Last_Day_Of_Special
GROUP BY customer_id,join_date, End_First_Week_Special, Last_Day
``
## Steps:
- Created a tempoary table using **WITH()** where we were able to find the 7 day special for each customer using **DATE_ADD** and **LAST_DAY**
- From the temporary ``CTE_Dates`` table use **SUM()** and **CASE()** to create a condtion where all orders within the first week special reiceved 2x points
- Use of **CASE()** also ensured that throughout the first month sushi still recieved 2x points 

## Answer 
| Customer_id | Join_date | End_Of_First_Week_Special | Last_Day_Of_Special |
|------------|------------|---------------------------|---------------------|
| A          | 2021-01-07 |    2021-01-14             |    1370             |
| B          | 2021-01-09 |    2021-01-16             |    820              |

- Customer A has a total of 1,370 points by the end of the month 
- Customer B has a total of 820 points by the end of the month

***

### Bonus.01 

--JOIN ALL THE THINGS--

--Recreate the table with: customer_id, order_date, product_name, price, member (yes or no)--

```sql
SELECT customer_id, order_date, product_name, price,
CASE 
    WHEN order_date >= join_date THEN 'Y'
    WHEN order_date < join_date THEN 'N'
    WHEN join_date IS NULL THEN 'N'
    END AS members
FROM Dannys_Diner.members FULL JOIN Dannys_Diner.sales USING(customer_id)
   JOIN Dannys_Diner.menu USING(product_id)
   ```
   
## Steps:
- Create a **Full_Join()** to combine all data from all three tables 
- Use **CASE()**  to set rules to identfy each customer as a member or not based on when they ordered and became a member
- Use **AS()** to label customer as a member or not (Y/N)
## Answer: 

| customer_id | order_date | product_name | price | members |
| ----------- | ---------- | -------------| ----- | ------ |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

- Customers A and B were members since January 
- Customer C never became a member 
***

### Bonus.02 

--Bonus.02 Rank All The Things--

-- Danny also requires further information about the ```ranking``` of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ```ranking``` values for the records when customers are not yet part of the loyalty program. --

```sql
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
```

## Steps:
- Create a view from preivous table stating y/n member 
- Use **CASE()** to set rulles for non-customers to recieve a rank of 'null' 
- Use **DENSE_RANK() OVER=( PARTITION BY()** to rank over ``customer_id``

