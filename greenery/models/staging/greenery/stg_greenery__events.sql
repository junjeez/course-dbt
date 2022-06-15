{{config(materialized = 'table')}}

WITH base as (
SELECT * FROM {{ source('public', 'events') }}
)

SELECT
  event_id AS event_guid
  , session_id
  , user_id
  , page_url
  , event_type
  , order_id
  , product_id
  , created_at AS created_at_utc
FROM base