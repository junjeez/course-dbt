{{config(materialized = 'view')}}

WITH base as (
SELECT * FROM {{ source('public', 'promos') }}
)

SELECT
  promo_id
  , discount
  , status
FROM base