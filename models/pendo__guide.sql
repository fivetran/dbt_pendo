{{ config(enabled=false) }}

with guide_event as (

    select *
    from {{ ref('pendo__guide_event') }}
),

calculate_metrics as (

    select
        guide_id,
        count(distinct visitor_id) as count_visitors,
        count(distinct account_id) as count_accounts,
        count(*) as count_events,
        min(occurred_at) as first_event_at,
        max(occurred_at) as last_event_at,

        {{ dbt_utils.pivot(column='type', values=dbt_utils.get_column_values(ref('pendo__guide_event'), 'type'), prefix='count_') }}
        ,
        {{ dbt_utils.pivot(column='type', values=dbt_utils.get_column_values(ref('pendo__guide_event'), 'type'), 
                            prefix='count_visitors_', agg='count', then_value='visitor_id', else_value='null', distinct=true) }}


        avg(num_minutes) as avg_num_minutes,
        avg(num_events) as avg_num_events

    from page_event
    group by 1
),

guide_info as (

    select *
    from {{ ref('int_pendo__guide_info') }}
)