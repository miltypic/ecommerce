{{ config(
    materialized='incremental',
    database='prod',
    unique_key="event_date",
     post_hook=[
     "DELETE FROM STAGING.EVENTS.AGG_DAILY_AUDIT WHERE DATEDIFF(DAY, UPDATED_AT, CURRENT_DATE) > 7",
     "INSERT INTO STAGING.EVENTS.AGG_DAILY_AUDIT(UPDATED_AT) VALUES(CURRENT_TIMESTAMP)"
     ]
   )

  }}

  with updated_dates as (

        (select distinct to_date(datetime) as event_date
        from {{ ref('fact_searches') }}
        where insertion_datetime > (select coalesce(max(updated_at), '1970-01-01 00:00:00'::timestamp)  from staging.events.agg_daily_audit))
        union
        (select distinct to_date(datetime) as event_date
        from {{ ref('fact_clicks') }}
        where insertion_datetime > (select coalesce(max(updated_at), '1970-01-01 00:00:00'::timestamp) from staging.events.agg_daily_audit))
  ),

  filtered_searches as (
        select updated_dates.event_date,
               searches.searchid
        from {{ ref('fact_searches') }} searches
        inner join updated_dates
            on to_date(searches.datetime) = updated_dates.event_date

  ),

  fitered_clicks as (
    select updated_dates.event_date,
               clicks.clickid,
               clicks.searchid
        from {{ ref('fact_clicks') }} clicks
        inner join updated_dates
            on to_date(clicks.datetime) = updated_dates.event_date

  )

  select filtered_searches.event_date,
        count(distinct filtered_searches.searchid) as search_cnt,
        count(distinct iff(fitered_clicks.clickid is null, null, fitered_clicks.clickid )) as click_cnt,
        round((click_cnt/search_cnt)*100,2) as click_ratio
  from filtered_searches
  left join fitered_clicks
    on filtered_searches.searchid = fitered_clicks.searchid
  group by filtered_searches.event_date
