with visitor_history as (

    select *
    from {{ ref('stg_pendo__visitor_history') }}

),

latest_visitor as (
    select
      *,
      row_number() over(partition by visitor_id {{ fivetran_utils.partition_by_source_relation(package_name='pendo') }} order by last_updated_at desc) as latest_visitor_index
    from visitor_history
)

select *
from latest_visitor
where latest_visitor_index = 1