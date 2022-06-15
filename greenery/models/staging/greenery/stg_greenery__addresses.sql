{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'addresses') }}
)

SELECT
  address_id AS address_guid
  , address AS street_address
  , zipcode
  , state
  , country
FROM base