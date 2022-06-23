{{config(materialized = 'table')}}

SELECT
    order_guid
    , user_id
    , order_cost
    , shipping_cost
    , order_total_cost
    , promo_id
    , promotion_amount_applied
    , count_unique_products_purchased
    , count_items_purchased
    , address_id
    , tracking_id
    , shipping_service
    , created_at_utc
    , estimated_delivery_utc
    , delivered_at_utc
    , delivery_status
    , CASE
        WHEN delivery_status = 'delivered' 
            AND (DATE_PART('day', (delivered_at_utc - estimated_delivery_utc)) > 0) THEN 'late'
        WHEN delivery_status = 'delivered' 
            AND (DATE_PART('day', (delivered_at_utc - estimated_delivery_utc)) = 0) THEN 'on_time'
        WHEN delivery_status = 'delivered' 
            AND (DATE_PART('day', (delivered_at_utc - estimated_delivery_utc)) > 0) THEN 'early'
        ELSE NULL
        END AS shipping_status
FROM {{ ref('fct_greenery__orders_summary')}}