with visitor as (

    select *
    from {{ ref('int_pendo__latest_visitor') }}

),

visitor_accounts as (

    select *
    from {{ ref('int_pendo__visitor_accounts') }}
),

nps_rating as (

    select * 
    from {{ ref('int_pendo__latest_nps_rating') }}
),

daily_metrics as (

    select *
    from {{ ref('int_pendo__visitor_daily_metrics') }}
),

calculate_metrics as (

    select
        visitor_id,
        count(distinct occurred_on) as count_active_days,
        count(distinct {{ dbt_utils.date_trunc('month', 'occurred_on') }} ) as count_active_months,
        sum(sum_minutes) as sum_minutes,
        sum(sum_events) as sum_events,
        sum(count_event_records) as count_event_records,
        sum(sum_minutes) / count(distinct occurred_on) as average_daily_minutes,
        sum(sum_events) / count(distinct occurred_on) as average_daily_events,
        min(occurred_on) as first_event_on,
        max(occurred_on) as last_event_on
        
    from daily_metrics
    group by 1
),

visitor_join as (

    select 
        visitor.*,
        visitor_accounts.accounts,
        visitor_accounts.count_accounts,
        nps_rating.nps_rating as latest_nps_rating,

        calculate_metrics.count_active_days,
        calculate_metrics.count_active_months,
        calculate_metrics.sum_minutes,
        calculate_metrics.sum_events,
        calculate_metrics.count_event_records,
        calculate_metrics.average_daily_minutes,
        calculate_metrics.average_daily_events,
        calculate_metrics.first_event_on,
        calculate_metrics.last_event_on

    from visitor
    left join visitor_accounts 
        on visitor.visitor_id = visitor_accounts.visitor_id
    left join nps_rating
        on visitor.visitor_id = nps_rating.visitor_id
    left join calculate_metrics
        on visitor.visitor_id = calculate_metrics.visitor_id
)

select *
from visitor_join