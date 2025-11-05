with alltime_metrics as (

    select *
    from {{ ref('int_pendo__guide_alltime_metrics') }}

),       

guide_info as (

    select *
    from {{ ref('int_pendo__guide_info') }}
),

final as (

    select
        guide_info.*,
        -- these won't be coalesced to 0
        {{ dbt_utils.star(from=ref('int_pendo__guide_alltime_metrics'), except=['source_relation', 'guide_id']) }}

    from guide_info
    left join alltime_metrics
        on guide_info.source_relation = alltime_metrics.source_relation
        and guide_info.guide_id = alltime_metrics.guide_id
)

select *
from final