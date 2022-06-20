**Part 1: Models**

What is our user repeat rate?
Repeat Rate = Users who purchased 2 or more times / users who purchased. <br>
*ANSWER: 79.8%*

```
WITH t1 AS (
SELECT
  user_id
  , COUNT (DISTINCT order_id) AS count_orders
FROM dbt.dbt_junji_s.orders_stg
GROUP BY 1
)

, t2 AS (
SELECT
  CAST(SUM(CASE WHEN count_orders >= 2 THEN 1 ELSE 0 END) AS DECIMAL(6,3)) AS count_repeat_purchasers
  , CAST(COUNT(DISTINCT user_id) AS DECIMAL(6,3)) AS count_any_purchasers
FROM t1
)

SELECT
  ROUND(count_repeat_purchasers * 100 / count_any_purchasers, 2)
FROM t2
```
<br>

What are good indicators of a user who will likely purchase again?
What about indicators of users who are likely NOT to purchase again?
> - How many purchases have they made with us in the past?
> - How long ago was their last purchase?
> - How long between purchases?
> - Did they use a promo for their purchase?

If you had more data, what features would you want to look into to answer
this question?
> - Review data on products.
<br>

Explain the marts models you added. Why did you organize the models in the way you did?
```
core
  - name: dim_greenery__user_summary
  - name: fct_greenery__orders_summary
marketing
  - name: dim_greenery__user_order_summary
  - name: fct_greenery__promo_orders
  - name: dim_greenery__user_addresses
product
  - name: dim_greenery__sessions_summary
  - name: fct_greenery__page_views
```
*I created models that I imagine can help answer questions for these teams. For instance, for the marketing teams the models are summarizing and aggregarating information about orders made by our users, where our users live, and what promotions have been used.*
<br>

---

**Part 2: Tests**
What assumptions are you making about each model? (i.e. why are you adding each test?)
> For my testing, I focused on making sure the unique ID for that model was correct (unique and not null). For other fields, we may not have data, such as how not every page visit results in an order. Or duplicates may be okay, such as one user making multiple orders.
<br>
Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
> From what I saw, my tests were running cleanly. However, I can imagine that in the future when I create my own tests with more specific logic I will see the need to adjust my models or tests.
<br>
Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
> Ideally, I would be able to schedule dbt build to run on a regular scheduled and test the models each time after it's built. I would want to receive an alert any time a test failed and would be able to correct it or let the stakeholders know that we were working on it.