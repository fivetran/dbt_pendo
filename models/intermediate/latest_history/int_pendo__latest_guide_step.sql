with guide_step_history as (

    select *
    from {{ ref('stg_pendo__guide_step_history') }}

),

latest_guide_step as (
    select
      *,
      row_number() over(partition by guide_id, step_id {{ fivetran_utils.partition_by_source_relation(package_name='pendo') }} order by guide_last_updated_at desc) as latest_guide_step_index
    from guide_step_history
)

select *
from latest_guide_step
where latest_guide_step_index = 1