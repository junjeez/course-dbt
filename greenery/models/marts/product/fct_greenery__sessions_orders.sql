{{config(materialized = 'table')}}

SELECT DISTINCT
    session_id
    , user_id
    , page_url
    , event_guid
    , events.product_id AS viewed_product_id
    , products.product_name AS viewed_product_name
    , order_items.order_id
    , order_items.product_id AS ordered_product_id
    , products_2.product_name AS ordered_product_name
    , order_items.quantity AS product_quantity
    , created_at_utc
FROM {{ ref('stg_greenery__events') }} AS events
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS order_items
    ON order_items.order_id = events.order_id
LEFT JOIN {{ ref('stg_greenery__products')}} AS products
    ON events.product_id = products.product_guid
LEFT JOIN {{ ref('stg_greenery__products')}} AS products_2
    ON order_items.product_id = products.product_guid