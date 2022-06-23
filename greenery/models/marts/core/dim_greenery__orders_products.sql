{{config(materialized = 'table')}}

{% set sql_statement %}
    select product_guid from {{ ref('stg_greenery__products') }}
{% endset %}

{% set product_ids = dbt_utils.get_query_results_as_dict(sql_statement) %}

SELECT
    orders.order_id
    , {% for product_guid in product_ids['product_guid'] | unique %}
    SUM(CASE WHEN products.product_guid = '{{product_guid}}' THEN product_quantity END) AS "count_purchased_{{product_guid}}"
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ref('stg_greenery__products')}} AS products
LEFT JOIN {{ref('fct_greenery__sessions_orders')}} AS orders
    ON products.product_guid = orders.ordered_product_id
GROUP BY 1
