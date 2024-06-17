-- The percentage of search having clicks per day, over the last 7 days, including overall summary value (using a single SQL query, adding a column to produce the summary value
-- for the overall period)

-- since need to use a single query, decided on window function
select distinct
    to_date(search.datetime) as search_date,
    count (search.searchid) over(partition by to_date(search.datetime) order by to_date(search.datetime)) as search_cnt,
    count(iff(click.searchid is null, null, click.searchid)) over(partition by to_date(search.datetime) order by to_date(search.datetime)) as click_cnt,
    round((click_cnt/search_cnt)*100,2) as daily_click_ratio,
    round((count(iff(click.searchid is null, null, click.searchid)) over() / count (search.searchid) over() )*100,2) as overall_click_ratio
from PROD.EVENTS.FACT_SEARCHES search
left join PROD.EVENTS.FACT_CLICKS click
        on search.searchid = click.searchid
where datediff('day', search_date, current_date()) < 7
order by search_date
;
