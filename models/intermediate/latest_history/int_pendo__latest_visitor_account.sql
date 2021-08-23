with visitor_account_history as (

    select *
    from {{ var('visitor_account_history') }}

),

latest_visitor as (
    select
      *,
      row_number() over(partition by visitor_id, account_id order by visitor_last_updated_at desc) as latest_visitor_index
    from visitor_account_history
)

select *
from latest_visitor
where latest_visitor_index = 1