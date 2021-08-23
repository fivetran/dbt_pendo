with feature_event as (

    select 
        *,
        cast( {{ dbt_utils.date_trunc('day', 'occurred_at') }} as date) as occurred_on

    from {{ ref('pendo__feature_event') }}
),

first_time_metrics as (
    
    select 
        *,
        -- get the first time this visitor/account has clicked on this feature
        min(occurred_on) over (partition by visitor_id, feature_id) as visitor_first_event_on,
        min(occurred_on) over (partition by account_id, feature_id) as account_first_event_on

    from feature_event
),

daily_metrics as (

    select
        occurred_on,
        feature_id,
        count(*) as count_clicks,
        count(distinct visitor_id) as count_visitors,
        count(distinct account_id) as count_accounts,
        count(distinct case when occurred_on = visitor_first_event_on then visitor_id end) as count_first_time_visitors,
        count(distinct case when occurred_on = account_first_event_on then account_id end) as count_first_time_accounts,
        avg(num_minutes) as avg_num_minutes,
        avg(num_events) as avg_num_events
        
    from first_time_metrics
    group by 1,2
),

total_feature_metrics as (

    select
        *,
        sum(count_clicks) over (partition by occurred_on) as total_feature_clicks,
        sum(count_visitors) over (partition by occurred_on) as total_feature_visitors,
        sum(count_accounts) over (partition by occurred_on) as total_feature_accounts

    from daily_metrics
),

final as (

    select 
        occurred_on,
        feature_id,
        count_clicks,
        count_visitors,
        count_accounts,
        count_first_time_visitors,
        count_first_time_accounts,
        count_visitors - count_first_time_visitors as count_return_visitors,
        count_accounts - count_first_time_accounts as count_return_accounts,
        avg_num_minutes,
        avg_num_events,
        round(100.0 * count_clicks / total_feature_clicks, 3) as percent_of_daily_feature_clicks,
        round(100.0 * count_visitors / total_feature_visitors, 3) as percent_of_daily_feature_visitors,
        round(100.0 * count_accounts / total_feature_accounts, 3) as percent_of_daily_feature_accounts
    
    from total_feature_metrics
)

select *
from final