{{config(materialized = 'view')}}

WITH base as (
SELECT * FROM {{ source('public', 'addresses') }}
)

SELECT
  address_id
  , address AS street_address
  , zipcode
  , state
  , country
FROM base