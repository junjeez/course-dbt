## PART 1: Snapshots

New snapshot: /snapshots/**orders.sql**
```
{% snapshot orders_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['status'],
    )
}}

SELECT * FROM {{ source('public', 'orders') }}

{% endsnapshot %}
```

***

<br>

## PART 2: 
*Product funnel:*
*Sessions with any event of type page_view --> add_to_cart --> checkout*

New model: /core/**fct_greenery__sessions_users**
```
{{config(materialized = 'table')}}

SELECT
    session_id
    , user_id
    , MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE NULL END) AS page_view_flag
    , MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE NULL END) AS add_to_cart_flag
    , MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE NULL END) AS checkout_flag
FROM {{ ref('stg_greenery__events') }} AS events
GROUP BY 1,2
```
<br>

**How are our users moving through the product funnel?**
```
SELECT
    SUM(page_view_flag) AS count_page_views
    , SUM(add_to_cart_flag) AS count_add_to_carts
    , SUM(checkout_flag) AS count_checkouts
FROM dbt_junji_s.fct_greenery__sessions_users
```
**Answer**: By session, 578 of users have viewed a page, 467 of users got to the add-to-cart page, and 361 got to the check out page.

<br>

**Which steps in the funnel have largest drop off points?**
```
SELECT
    ROUND(SUM(add_to_cart_flag)*100 / SUM(page_view_flag), 2) AS conversion_1
    , ROUND(SUM(checkout_flag)*100 / SUM(add_to_cart_flag), 2) AS conversion_2
FROM dbt_junji_s.fct_greenery__sessions_users
```
**Answer**: The conversion rate for step 1 is 80%. The conversion rate for step 2 is 77%.  Therefore, our biggest drop off point is between add to cart and checkout.

<br>

New exposure: /models/**exposures.yml**
```
version: 2

exposures:  
  - name: Product Funnel Dashboard
    description: >
      Core model for the product funnel dashboard.
    type: dashboard
    owner:
      name: Junji Shang
      email: junji.shang@colorofchange.org
    depends_on:
      - ref('fct_greenery__sessions_users')
```

***

<br>

## PART 3: Reflection
**3A**
My organization is starting to adopt dbt for the first time. There are many things we want to implement over time. Two things I'm excited for is adopting dbt's approach to Model Layers and using the DAG to plan out our models. I think this will help in so many ways of removing the need to code in our "business logic" every time we use source data, facilitating better sharing of models across team members, and depreciating old models. The second thing I'm excited for is tests and how they can help check data quality. Right now we have many products where we don't notice there was a problem with updating the models until a user lets us know. 
