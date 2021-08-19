with feature_event as (

    select *
    from {{ ref('pendo__feature_event') }}
),

calculate_metrics as (

    select
        feature_id,
        count(distinct visitor_id) as count_visitors,
        count(distinct account_id) as count_accounts,
        count(*) as count_clicks,
        min(occurred_at) as first_click_at,
        max(occurred_at) as last_click_at,
        avg(num_minutes) as avg_num_minutes,
        avg(num_events) as avg_num_events

    -- maybe some definition of active users? might be overkill with the visitor_feature model
    -- also # of days without any events since creation? eh 
    from feature_event
    group by 1
),

feature_info as (

    select *
    from {{ ref('int_pendo__feature_info') }}

),

final as (

    select 
        feature_info.*,
        calculate_metrics.count_visitors,
        calculate_metrics.count_accounts,
        calculate_metrics.count_clicks,
        calculate_metrics.first_click_at,
        calculate_metrics.last_click_at,
        calculate_metrics.avg_num_minutes,
        calculate_metrics.avg_num_events

    from feature_info 
    left join calculate_metrics 
        on feature_info.feature_id = calculate_metrics.feature_id
)

select *
from final