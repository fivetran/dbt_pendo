with page_event as (

    select 
        *,
        cast( {{ dbt_utils.date_trunc('day', 'occurred_at') }} as date) as occurred_on

    from {{ ref('pendo__page_event') }}
),

first_time_metrics as (
    
    select 
        *,
        -- get the first time this visitor/account has viewed this page
        min(occurred_on) over (partition by visitor_id, page_id) as visitor_first_event_on,
        min(occurred_on) over (partition by account_id, page_id) as account_first_event_on

    from page_event
),

daily_metrics as (

    select
        occurred_on,
        page_id,
        count(*) as count_pageviews,
        count(distinct visitor_id) as count_visitors,
        count(distinct account_id) as count_accounts,
        count(distinct case when occurred_on = visitor_first_event_on then visitor_id end) as count_first_time_visitors,
        count(distinct case when occurred_on = account_first_event_on then account_id end) as count_first_time_accounts,
        avg(num_minutes) as avg_num_minutes,
        avg(num_events) as avg_num_events
        
    from first_time_metrics
    group by 1,2
),

total_page_metrics as (

    select
        *,
        sum(count_pageviews) over (partition by occurred_on) as total_pageviews,
        sum(count_visitors) over (partition by occurred_on) as total_page_visitors,
        sum(count_accounts) over (partition by occurred_on) as total_page_accounts

    from daily_metrics
),

final as (

    select 
        occurred_on,
        page_id,
        count_pageviews,
        count_visitors,
        count_accounts,
        count_first_time_visitors,
        count_first_time_accounts,
        count_visitors - count_first_time_visitors as count_return_visitors,
        count_accounts - count_first_time_accounts as count_return_accounts,
        round(avg_num_minutes, 3) as avg_num_minutes,
        round(avg_num_events, 3) as avg_num_events,
        round(100.0 * count_pageviews / total_pageviews, 3) as percent_of_daily_pageviews,
        round(100.0 * count_visitors / total_page_visitors, 3) as percent_of_daily_page_visitors,
        round(100.0 * count_accounts / total_page_accounts, 3) as percent_of_daily_page_accounts
    
    from total_page_metrics
)

select *
from final