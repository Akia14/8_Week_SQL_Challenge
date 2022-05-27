# 🥑 Case Study #3 - Foodie-Fi

## Customer Journey

Based off the 8 sample customers provided in the sample subscriptions table below, write a brief description about each customer’s onboarding journey.

<img width="261" alt="Screenshot 2021-08-17 at 11 36 10 PM" src="https://user-images.githubusercontent.com/81607668/129756709-75919d79-e1cd-4187-a129-bdf90a65e196.png">

**Answer:**

````sql
SELECT
  s.customer_id,f.plan_id, f.plan_name,  s.start_date
FROM foodie_fi.plans f
JOIN foodie_fi.subscriptions s
  ON f.plan_id = s.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19)
````

<img width="556" alt="image" src="https://user-images.githubusercontent.com/81607668/129758340-b7cd527c-31f3-4f33-8d99-5b0a4baab378.png">

- We'll analyze three customers (1, 13, and 15) and explore their customer journey.

<img width="560" alt="image" src="https://user-images.githubusercontent.com/81607668/129757897-df606bb6-aeb8-4235-8244-d61a3952a84a.png">

- Customer 1 started the free trial in August 2020 and subscribed onto the basic plan after the 7-day trial ended

<img width="512" alt="image" src="https://user-images.githubusercontent.com/81607668/129761134-7fa840f5-673e-4ec6-8831-e3971c1fcd50.png">

- Customer 13 started the free trial August 2020 and subscribed to the basic plan after the 7-day trial eneded
.Three months later customer 13 upgraded to the pro plan.

<img width="549" alt="image" src="https://user-images.githubusercontent.com/81607668/129761434-39009802-c813-437d-a292-ddd26ac8ac29.png">

- Customer 15 started the free trial March 2020 then upgraded to the pro plan after the 7-day trial ended. The next month customer 15 churned
***

