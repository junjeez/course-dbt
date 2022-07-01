{{config(materialized = 'table')}}

{% set event_type_flag =  create_event_type_flags() %}

SELECT
    {% for shipping_status in shipping_statuses %}
    COUNT(CASE WHEN shipping_status = '{{shipping_status}}' THEN order_guid END) AS {{shipping_status}}_count_orders
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ ref('stg_greenery__events') }}
