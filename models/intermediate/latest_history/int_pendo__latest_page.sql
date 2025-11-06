with page_history as (

    select *
    from {{ ref('stg_pendo__page_history') }}

),

latest_page as (
    select
      *,
      row_number() over(partition by page_id {{ pendo.partition_by_source_relation() }} order by last_updated_at desc) as latest_page_index
    from page_history
)

select *
from latest_page
where latest_page_index = 1