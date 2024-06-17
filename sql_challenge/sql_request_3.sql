-- List the 10 most active users (by number of searches) having at least 1 click on a document coming from a source starting with “Confluence”.
----------------------------
with top_users as (

-- rank by the number of searches consider rank for those with the same value
select userid,
        search_cnt,
        dense_rank() over(order by search_cnt desc) as value_rank
from(
    select
            search.userid,
            count(distinct search.searchid) as search_cnt,
    from PROD.EVENTS.FACT_SEARCHES search
    -- to ensure at least 1 click
    inner join PROD.EVENTS.FACT_CLICKS click
            on  search.searchid = click.searchid
            -- to minimize formatting using ilike
                and click.sourcename ilike 'confluence%'
    group by search.userid
    )
    -- filtering on top 10 values
    qualify value_rank <= 10

)

select  userid,
        search_cnt,
        value_rank
from top_users
;