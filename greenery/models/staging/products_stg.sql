{{config(materialized = 'view')}}

WITH base as (
SELECT * FROM {{ source('public', 'products') }}
)

SELECT
  product_id
  , name
  , price
  , inventory
FROM base