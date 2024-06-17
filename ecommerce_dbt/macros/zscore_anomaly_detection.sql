{% macro zscore_anomaly_detection(table_name, date_field, measure) %}

   with data_distribution as (
        select  to_date({{date_field}}) as event_date,
                count( {{measure}} ) as event_cnt
        from {{table_name}}
        group by all
        order by event_date
),

log_transformation as (

        select event_date,
                ln(event_cnt) as log_cnt
        from data_distribution
),

log_mean_calculation as (

        select avg(log_cnt) as log_mean
        from log_transformation
),

centered_distribution as  (

        SELECT  event_date,
                log_cnt - (SELECT log_mean FROM log_mean_calculation) AS centered_log_value
           FROM log_transformation

),

 centered_z_scores as (

        select event_date,
                (centered_log_value - (SELECT avg(centered_log_value) FROM centered_distribution)) / (SELECT stddev(centered_log_value) FROM centered_distribution) as zscore
        from centered_distribution

)

select zscores.event_date,
        dist.event_cnt,
        zscores.zscore
from centered_z_scores zscores
inner join data_distribution dist
    using(event_date)
where abs(zscore) > 1

{% endmacro %}
