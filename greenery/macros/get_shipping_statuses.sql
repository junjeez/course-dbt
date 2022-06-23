{% macro get_shipping_statuses() %}
{{return(["late", "on_time", "early"])}}
{% endmacro %}