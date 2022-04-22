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
### 6.Which item was purchased first by the customer after they became a member?
### 7.Which item was purchased just before the customer became a member?
### 8.What is the total items and amount spent for each member before they became a member?
### 9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
### 1..In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
### Bonus.1 
### Bonus.2 
