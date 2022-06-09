How many users do we have?
*Answer: 130*
```
SELECT COUNT(DISTINCT user_id) FROM dbt.dbt_junji_s.users_stg
```

On average, how many orders do we receive per hour?
*Answer: Average of 7.52 order per hour each day*
```
WITH t1 AS (
SELECT
  order_id
  , date_trunc('hour', created_at_utc) AS time
FROM dbt.dbt_junji_s.orders_stg
)

, t2 AS (
SELECT
  COUNT (DISTINCT order_id) AS count_orders
  , time
FROM t1
GROUP BY time
)

SELECT
 AVG(count_orders)
FROM t2
```


On average, how long does an order take from being placed to being delivered?
*Answer: Average of 3 days and 21 hours.*
```
WITH t1 AS (
SELECT
  order_id
  , delivered_at_utc - created_at_utc AS time_difference
FROM dbt.dbt_junji_s.orders_stg
)

, t2 AS (
SELECT
  AVG(time_difference) AS average_time
FROM t1
)

SELECT
  date_part('day', average_time) AS days
  , date_part('hour', average_time) AS hours
FROM t2
```


How many users have only made one purchase? Two purchases? Three+ purchases?
*Answer: 25 users with 1 purchase, 28 users with 2 purchases, 71 users with 3+ purchases*
```
WITH t1 AS (
SELECT
  user_id
  , COUNT (DISTINCT order_id) AS count_orders
FROM dbt.dbt_junji_s.orders_stg
GROUP BY 1
)

SELECT
  CASE WHEN count_orders >= 3 THEN '3+'
    WHEN count_orders = 2 THEN '2'
    WHEN count_orders = 1 THEN '1'
    ELSE '0'
    END AS purchases
  , COUNT(user_id) AS count_users
FROM t1
GROUP BY 1
```


On average, how many unique sessions do we have per hour?
*Answer: 16 sessions per hour on average*
```
WITH t1 AS (
SELECT
  date_trunc('hour', created_at_utc) AS time_difference
  , COUNT(DISTINCT session_id) AS count_sessions
FROM dbt.dbt_junji_s.events_stg
GROUP BY 1
)

SELECT
  AVG(count_sessions)
FROM t1
```