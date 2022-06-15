{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'products') }}
)

SELECT
  product_id AS product_guid
  , name AS product_name
  , price AS product_price
  , inventory AS product_inventory
FROM base