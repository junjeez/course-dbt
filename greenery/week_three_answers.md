## PART 1

**What is our overall conversion rate?**  
*NOTE: conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions.*  
ANSWER: 62%
```
SELECT
   ROUND(SUM(order_made)*100 / COUNT(DISTINCT session_id), 2) AS conversion_rate
FROM dbt_junji_s.dim_greenery__sessions_summary
```
  
**What is our conversion rate by product?**  
*NOTE: Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product*

| Product ID | Product Name | Conversion Rate (%) |
| ----------- | ----------- | ----------- |
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 | String of pearls | 60 |
| 74aeb414-e3dd-4e8a-beef-0fa45225214d | Arrow Head | 55 |
| c17e63f7-0d28-4a95-8248-b01ea354840e | Cactus | 54 |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d | Bamboo | 53 |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160 | ZZ Plant | 53 |
*(limiting to 5 products with highest conversion rate)*

```
WITH viewed AS (
  SELECT
    viewed_product_id
    , viewed_product_name
    , COUNT(DISTINCT session_id) AS count_sessions_with_views
  FROM dbt_junji_s.fct_greenery__sessions_orders
  GROUP BY 1,2
)

, ordered AS (
  SELECT
    ordered_product_id
    , ordered_product_name
    , COUNT(DISTINCT session_id) AS count_sessions_with_orders
  FROM dbt_junji_s.fct_greenery__sessions_orders
  GROUP BY 1,2
  )

SELECT
  COALESCE(viewed_product_id, ordered_product_id) AS product_id
  , COALESCE(viewed_product_name, ordered_product_name) AS product_name
  , ROUND(count_sessions_with_orders * 100 / count_sessions_with_views, 2) AS conversion_rate
FROM viewed
FULL OUTER JOIN ordered
  ON viewed.viewed_product_id = ordered.ordered_product_id
WHERE product_id IS NOT NULL
```

***

## PART 2
Macro:  /macros/**get_shipping_statuses.sql**
```
{% macro get_shipping_statuses() %}
{{return(["late", "on_time", "early"])}}
{% endmacro %}
```

Model:  /models/core/**dim_greenery__shipping_service_performance**
```
{{config(materialized = 'table')}}

{% set shipping_statuses =  get_shipping_statuses() %}

SELECT
   shipping_service
    , {% for shipping_status in shipping_statuses %}
    COUNT(CASE WHEN shipping_status = '{{shipping_status}}' THEN order_guid END) AS {{shipping_status}}_count_orders
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ref('fct_greenery__orders_status')}}
GROUP BY 1
WHERE shipping_service IS NOT NULL
```

Documentation:  macros/**junji_macros.yml**
```
version: 2

macros:
  - name: get_shipping_statuses
    description: "List of shipping statuses based on estimated and actual delivery date."
    docs: 
      show: true
```
