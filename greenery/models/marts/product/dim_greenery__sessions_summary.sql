{{config(materialized = 'table')}}

SELECT
    session_id
    , user_id
    , COUNT(DISTINCT page_url) AS count_pages_visited
    , COUNT(DISTINCT event_guid) AS count_events
    , CASE WHEN
        COUNT(DISTINCT order_items.order_id) = 1 THEN 'Y'
        ELSE 'N'
        END AS order_made
    , COUNT(DISTINCT order_items.product_id) AS count_products_viewed
    , SUM(order_items.quantity) AS count_products_ordered
    , MIN(created_at_utc) AS time_first_page_opened_utc
    , MAX(created_at_utc) - MIN(created_at_utc) AS time_spent_during_session
FROM {{ ref('stg_greenery__events') }} AS events
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS order_items
    ON order_items.order_id = events.order_id
GROUP BY session_id, user_id