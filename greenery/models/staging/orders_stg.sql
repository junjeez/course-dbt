{{config(materialized = 'view')}}

WITH base as (
SELECT * FROM {{ source('public', 'orders') }}
)

SELECT
  order_id
  , user_id
  , promo_id
  , created_at AS created_at_utc
  , order_cost
  , shipping_cost
  , order_total
  , address_id
  , tracking_id
  , shipping_service
  , estimated_delivery_at AS estimated_delivery_utc
  , delivered_at AS delivered_at_utc
  , status
FROM base