{{config(materialized = 'table')}}

SELECT
    state
    , country
    , COUNT(user_guid) AS count_users
    , COUNT(order_guid) AS count_orders
FROM {{ ref('stg_greenery__users') }} AS users
LEFT JOIN {{ ref('stg_greenery__addresses')}} AS addresses
    ON users.address_id = addresses.address_guid
LEFT JOIN {{ ref('stg_greenery__orders') }} AS orders
    ON orders.user_id = users.user_guid
GROUP BY state, country