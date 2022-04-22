------------------
--Case Study 1---
--Author: A'Kia Harris
--Date:April 4,2022
--Tool used: Big Query 
------------------

--1. What is the total amount each customer spent at the restaurant?
SELECT customer_id, SUM(price) AS Amount_Spent
FROM Dannys_Diner.sales AS s
JOIN Dannys_Diner.menu AS m
USING( proudct_id)
GROUP BY customer_id;


--2.How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) AS Days_Visited
FROM Dannys_Diner.sales
GROUP BY customer_id

--3. What was the first item from the menu purchased by each customer?

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

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT product_name, COUNT(product_name) AS Times_purchased,SUM(price) AS Revenue_From_Item
FROM Dannys_Diner.sales JOIN Dannys_Diner.menu USING(product_id)
GROUP BY product_name 
ORDER BY Times_purchased DESC

--5. Which item was the most popular for each customer?

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

--6.Which item was purchased first by the customer after they became a member?

SELECT customer_id, product_name, MIN(order_date) AS First_Order_As_Member
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date >= join_date
GROUP BY customer_id, product_name
ORDER BY First_Order_As_Member

--7. Which item was purchased just before the customer became a member?

SELECT customer_id, product_name, MAX(order_date) AS Last_Regular_Order
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date <= join_date
GROUP BY customer_id, product_name
ORDER BY Last_Regular_Order

--8. What is the total items and amount spent for each member before they became a member?

SELECT customer_id, COUNT(product_name) AS Total_Items, SUM(price) AS Total_Spent
FROM Dannys_Diner.sales JOIN Dannys_Diner.members USING(customer_id)
    JOIN Dannys_Diner.menu USING(product_id)
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY Total_Spent DESC

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

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

--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

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

--Bonus Questions--

--Bonus.1 JOIN ALL THE THINGS--
--Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)--

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

--Bonus.2 RANK ALL THINGS--
--Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

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
