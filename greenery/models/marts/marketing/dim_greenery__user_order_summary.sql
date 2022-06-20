{{config(materialized = 'table')}}

SELECT
    user_guid
    , COUNT(DISTINCT order_guid) AS count_orders
    , SUM(quantity) AS count_products_purchased
    , COUNT(promo_id) AS count_promos_used
    , SUM(order_cost) AS total_money_spent
    , SUM(promo_discount) AS money_saved_with_promos
    , AVG(orders.delivered_at_utc - orders.created_at_utc) AS avg_delivery_time
FROM {{ ref('stg_greenery__users') }} AS users
LEFT JOIN {{ ref('stg_greenery__orders') }} AS orders
    ON users.user_guid = orders.user_id
LEFT JOIN {{ ref('stg_greenery__promos') }} AS promos
    ON orders.promo_id = promos.promo_guid
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS items
    ON orders.order_guid = items.order_id
GROUP BY user_guid