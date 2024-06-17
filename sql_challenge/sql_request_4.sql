-- List the top 10 most popular items and display their average click rank.

with top_10_items as
(
    select  item,
            click_cnt,
            dense_rank() over(order by click_cnt desc) as value_rank
    from (
    select
         c_product as item,
         count(distinct items.clickid) as click_cnt
    FROM PROD.EVENTS.FACT_CLICKS items
    group by item
    )
    qualify value_rank <= 10

)
select
         top_10_items.item,
         avg(CLICK.clickrank) as avg_click_rank

FROM PROD.EVENTS.FACT_CLICKS CLICK
-- only consider click rank for those who are in top 10
inner join top_10_items
    on CLICK.c_product = top_10_items.item

group by top_10_items.item
-- ascending order because the lower the rank the better
order by avg_click_rank asc
;
