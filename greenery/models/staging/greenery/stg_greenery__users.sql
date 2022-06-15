{{
  config(
    materialized = 'table'
  )
}}

WITH base as (
SELECT * FROM {{ source('public', 'users') }}
)

SELECT
  user_id AS user_guid
  , first_name
  , last_name
  , email
  , phone_number
  , address_id
  , created_at AS created_at_utc
  , updated_at AS updated_at_utc
FROM base