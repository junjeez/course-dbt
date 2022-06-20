{{config(materialized = 'table')}}

SELECT
    page_url
    , DATE_PART('year', created_at_utc) AS year
    , DATE_PART('week', created_at_utc) AS week
    , COUNT(DISTINCT event_guid) AS count_views
FROM {{ ref('stg_greenery__events') }} AS events
WHERE event_type = 'page_view'
GROUP BY page_url, year, week