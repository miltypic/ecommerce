{% macro timeliness_check(table_name, date_field) %}

    select max( {{date_field}} ) as latest_date,
                datediff(day, latest_date, current_date) as time_diff_today_days
    from {{table_name}}
    having time_diff_today_days > 1

{% endmacro %}