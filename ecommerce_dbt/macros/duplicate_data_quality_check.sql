{% macro duplicate_detection(table_name, check_fields) %}

    select
    {% for field in check_fields %}
        {{ field }} {% if not loop.last %}, {% endif %}
    {% endfor %},
    count(*) as row_count
    from {{ table_name }}
    group by all
    having row_count > 1

{% endmacro %}
