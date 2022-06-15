{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'orders') }}
)

SELECT
  order_id AS order_guid
  , user_id
  , promo_id
  , order_cost
  , shipping_cost
  , order_total AS order_total_cost
  , address_id
  , tracking_id
  , shipping_service
  , created_at AS created_at_utc
  , estimated_delivery_at AS estimated_delivery_utc
  , delivered_at AS delivered_at_utc
  , status AS delivery_status
FROM base