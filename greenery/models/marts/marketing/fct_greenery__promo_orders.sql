{{config(materialized = 'table')}}

SELECT
    promo_guid
    , COUNT(DISTINCT order_guid) AS count_orders_applied
    , COUNT(DISTINCT user_id) AS count_users_applied
    , SUM(promo_discount) AS total_discounts_from_promos
    , MIN(orders.created_at_utc) AS date_promo_first_applied_utc
    , MAX(orders.created_at_utc) AS date_promo_last_applied_utc
    , promo_status AS current_promo_status
FROM {{ ref('stg_greenery__promos') }} AS promos
LEFT JOIN {{ ref('stg_greenery__orders') }} AS orders
    ON orders.promo_id = promos.promo_guid
GROUP BY promo_guid, current_promo_status