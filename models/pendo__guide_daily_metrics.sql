with spine as (

    select *
    from {{ ref('int_pendo__calendar_spine') }}
),

daily_metrics as (

    select *
    from {{ ref('int_pendo__guide_daily_metrics') }}
),

guide as (

    select 
        *,
        cast( {{ dbt.date_trunc('day', 'created_at') }} as date) as created_on

    from {{ ref('pendo__guide') }}
),

guide_spine as (

    select 
        spine.date_day,
        guide.guide_id,
        guide.guide_name
    
    from spine 
    join guide
        on spine.date_day >= guide.created_on
        and spine.date_day <= cast( {{ dbt.current_timestamp_backcompat() }} as date)

),

final as (

    {% set exclude_fields = [ 'guide_id', 'occurred_on'] %}

    select
        guide_spine.date_day,
        guide_spine.guide_id,
        guide_spine.guide_name,
        -- use star since we're pivoting out different event types
        -- metrics won't be coalesced with 0 
        {{ dbt_utils.star(from=ref('int_pendo__guide_daily_metrics'), except=exclude_fields) }}

    from guide_spine
    left join daily_metrics
        on guide_spine.date_day = daily_metrics.occurred_on
        and guide_spine.guide_id = daily_metrics.guide_id
)

select *
from final