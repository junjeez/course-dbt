{{config(materialized = 'table')}}

SELECT
    user_guid
    , first_name
    , last_name
    , email
    , phone_number
    , users.address_id
    , users.created_at_utc
    , users.updated_at_utc
    , COUNT(DISTINCT session_id) AS count_sessions
    , COUNT(DISTINCT order_guid) AS count_orders
    , SUM(quantity) AS count_products_purchased
FROM {{ ref('stg_greenery__users') }} AS users
LEFT JOIN {{ ref('stg_greenery__events') }} AS events
    ON users.user_guid = events.user_id
LEFT JOIN {{ ref('stg_greenery__orders') }} AS orders
    ON users.user_guid = orders.user_id
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS items
    ON orders.order_guid = items.order_id
GROUP BY 1,2,3,4,5,6,7,8