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
        {{ dbt_utils.star(from=ref('int_pendo__guide_alltime_metrics'), except='guide_id' if target.type != 'snowflake' else 'GUIDE_ID') }}

    from guide_info
    left join alltime_metrics
        on guide_info.guide_id = alltime_metrics.guide_id
)

select *
from final