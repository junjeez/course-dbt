{{config(materialized = 'table')}}

{% set shipping_statuses =  get_shipping_statuses() %}

SELECT
   shipping_service
    , {% for shipping_status in shipping_statuses %}
    COUNT(CASE WHEN shipping_status = '{{shipping_status}}' THEN order_guid END) AS {{shipping_status}}_count_orders
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ref('fct_greenery__orders_status')}}
WHERE shipping_service IS NOT NULL
GROUP BY 1