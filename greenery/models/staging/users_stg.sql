{{
  config(
    materialized = 'view'
  )
}}

WITH base as (
SELECT * FROM {{ source('public', 'users') }}
-- {{'source_name', 'table_name'}}
)

SELECT
  user_id
  , first_name
  , last_name
  , email
  , phone_number
  , created_at AS created_at_utc
  , updated_at AS updated_at_uts
  , address_id
FROM base