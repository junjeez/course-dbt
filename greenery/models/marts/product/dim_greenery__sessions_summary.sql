{{config(materialized = 'table')}}

SELECT
    session_id
    , user_id
    , COUNT(DISTINCT page_url) AS count_pages_visited
    , COUNT(DISTINCT event_guid) AS count_eventsjnn
    , CASE WHEN
        COUNT(DISTINCT order_id) = 1 THEN 1
        ELSE NULL
        END AS order_made
    , COUNT(DISTINCT viewed_product_id) AS count_unique_products_viewed
    , COUNT(DISTINCT ordered_product_id) AS count_unique_products_ordered
    , SUM(product_quantity) AS count_number_of_products_ordered
    , MIN(created_at_utc) AS time_first_page_opened_utc
    , MAX(created_at_utc) - MIN(created_at_utc) AS time_spent_during_session
FROM {{ ref('fct_greenery__sessions_orders') }}
GROUP BY session_id, user_id