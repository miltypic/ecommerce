-- List all visits with at least one clicks

with searches_with_clicks as (
-- look at all searches
-- inner join with clicks to see if any clicks took place
    select distinct
           search.VISITID,
           search.DATETIME,
           search.VISITORID
    from PROD.EVENTS.FACT_SEARCHES search
    inner join PROD.EVENTS.FACT_CLICKS click
            using(visitid)
),
custom_events_with_clicks as (
-- look at all custom events
-- inner join with clicks to see if any clicks took place
     select distinct
            customevents.VISITID,
            customevents.DATETIME,
            customevents.VISITORID
     from PROD.EVENTS.FACT_CUSTOM_EVENTS customevents
      inner join PROD.EVENTS.FACT_CLICKS click
            using(visitid)

),
unified_visits as (
        (select * from searches_with_clicks)
        union -- NOT ALL to make sure no duplicates
        (select * from custom_events_with_clicks)
)

select *
from unified_visits
;
