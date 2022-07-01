{{config(materialized = 'table')}}

SELECT
    session_id
    , user_id
    , MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE NULL END) AS page_view_flag
    , MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE NULL END) AS add_to_cart_flag
    , MAX(CASE WHEN event_type = 'checkout' THEN 1 ELSE NULL END) AS checkout_flag
FROM {{ ref('stg_greenery__events') }} AS events
GROUP BY 1,2