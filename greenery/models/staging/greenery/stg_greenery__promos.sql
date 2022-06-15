{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'promos') }}
)

SELECT
  promo_id AS promo_guid
  , discount AS promo_discount
  , status AS promo_status
FROM base