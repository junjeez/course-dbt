{{config(materialized = 'table')}}

SELECT
    orders.order_guid
    , orders.user_id
    , orders.order_cost
    , orders.shipping_cost
    , orders.order_total_cost
    , orders.promo_id
    , SUM(promos.promo_discount) AS promotion_amount_applied
    , COUNT(DISTINCT items.product_id) AS count_unique_products_purchased
    , SUM(items.quantity) AS count_items_purchased
    , orders.address_id
    , orders.tracking_id
    , orders.shipping_service
    , orders.created_at_utc
    , orders.estimated_delivery_utc
    , orders.delivered_at_utc
    , orders.delivery_status
FROM {{ ref('stg_greenery__orders') }} AS orders
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS items
    ON orders.order_guid = items.order_id
LEFT JOIN {{ ref('stg_greenery__promos') }} AS promos
    ON orders.promo_id = promos.promo_guid
GROUP BY 1,2,3,4,5,6,10,11,12,13,14,15,16