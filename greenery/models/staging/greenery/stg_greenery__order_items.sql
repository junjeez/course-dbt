{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'order_items') }}
)

SELECT
  order_id
  , product_id
  , quantity
FROM base