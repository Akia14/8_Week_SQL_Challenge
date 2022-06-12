----
Data Analysis 
---


1. How many customers has Foodie-Fi ever had?
 ```sql
 SELECT COUNT(DISTINCT customer_id) as Overall_customer_count
FROM foodie_fi.subscriptions
```
| Overall_customer_count|
|-----------------------|
|1,000|

---
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

```sql
SELECT month_name as month, trial_subscriptions
FROM
(
SELECT DATE_PART('month',start_date) as month_date,
TO_CHAR(start_date, 'Month') as month_name,
COUNT(*) trial_subscriptions
FROM foodie_fi.plans as p
INNER JOIN foodie_fi.subscriptions as s 
ON p.plan_id = s.plan_id
WHERE plan_name = 'trial'
GROUP BY month_date, month_name
ORDER BY month_date 
) AS trial_subs
```
|Month| Trial_Subscriptions|
|-----|------------------|
| January | 88|
|February | 68|
|March | 94|
|April | 81|
|May | 88|
|June | 79|
|July | 89|
|August|88|
|September| 87|
|October| 79|
|Novemer | 75|
|December| 84|
---
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

```sql
Select DATE_PART('year',start_date)as year, plan_name, count(customer_id) as events
FROM foodie_fi.plans as p
INNER JOIN foodie_fi.subscriptions as s 
ON p.plan_id = s.plan_id
WHERE DATE_PART('year',start_date) > 2020
GROUP BY plan_name, year
ORDER BY plan_name
```
| plan_name     | events |
| ------------- | ---------------- |
| basic monthly | 8                |
| churn         | 71               |
| pro annual    | 63               |
| pro monthly   | 60               |

- There were no new events/ trial sign-ups after the year 2020 
---

4.  What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
- In this query we had to make sure we could generate the total number of customer churrned as well as the percentage all in one query. The `CASE` statement is perfect for this uses. We also used  `::NUMERIC` to ensure we can get to the 1st decimal place percentage 
```sql
SELECT
  SUM(CASE WHEN plan_name = 'churn' THEN 1 ELSE 0 END) AS churn_customers,
  ROUND(
    100 * SUM(CASE WHEN plan_name = 'churn' THEN 1 ELSE 0 END) ::NUMERIC /
      COUNT(DISTINCT customer_id), 1
  ) AS percentage
FROM foodie_fi.plans as p
INNER JOIN foodie_fi.subscriptions as s 
ON p.plan_id = s.plan_id;
```
|churn_customers|percentage|
|--------------|-----------|
|307|30.7|

---
5.  How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
- To get the proper final result we must create a table to rank each customer's plans using `ROW_NUMBER()` and use `PARTITION BY` to generate a rank per unique customer 
- We will find the customers immediately after their free trial by filtering the table by the `Trial Plan` and `Row/Rank #2` as this will indicate they churned directly after their trial 


```sql
WITH CTE_RANK AS (
SELECT customer_id, plan_name, p.plan_id,
  ROW_NUMBER() OVER(PARTITION BY customer_id
    ORDER BY p.plan_id) as plan_rank
FROM foodie_fi.plans as p
  INNER JOIN foodie_fi.subscriptions as s
  ON p.plan_id = s.plan_id
)
SELECT COUNT(*) AS churned_customers, 
  ROUND(100 * COUNT(*) ::NUMERIC/ 
    ( SELECT COUNT(DISTINCT customer_id) FROM foodie_fi.subscriptions)) AS Churn_percentage
FROM CTE_RANK
WHERE plan_id = 4
AND plan_rank = 2
```
|Churned_customers|Churn_percentage|
|-----------------|----------------|
|92|9|

---

