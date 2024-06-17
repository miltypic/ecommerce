--List all events related to visits, in order of date, adding the following information
--o The sequence number (1 to N) of the event over the visit
--o The time difference (in milliseconds) between the event and the previous one. The first event having 0 or null since no previous event


with click_events as (

    select 'Click' as event_type,
            visitid,
            datetime as event_datetime
    from PROD.EVENTS.FACT_CLICKS
),

search_events as (

    select 'Search' as event_type,
            visitid,
            datetime as event_datetime
    from PROD.EVENTS.FACT_SEARCHES
),

custom_events as (
    select eventtype as event_type,
            visitid,
            datetime as event_datetime
    from PROD.EVENTS.FACT_CUSTOM_EVENTS

),

unified_events as (

        select event_type, visitid, event_datetime from click_events
        union all
        select event_type, visitid, event_datetime from search_events
        union all
        select event_type, visitid, event_datetime from custom_events

)

select  event_type,
        visitid,
        event_datetime,
        row_number() over (partition by visitid order by event_datetime) as sequence_number,
        coalesce(timediff('milliseconds', lag(event_datetime, 1)  over (partition by visitid order by event_datetime), event_Datetime), 0) as time_difference_milliseconds
from unified_events
order by visitid,
         event_datetime
;

