{%- set guide_event_types = (dbt_utils.get_column_values(table=ref('pendo__guide_event'), column='type') or []) if execute and flags.WHICH in ('run', 'build') else [] -%}

-- making this its own model so i can use dbt_utils.star for the pivoted out columns
with guide_event as (

    select *
    from {{ ref('pendo__guide_event') }}
),

calculate_metrics as (

    select
        source_relation,
        guide_id,
        count(distinct visitor_id) as count_visitors,
        count(distinct account_id) as count_accounts,
        count(*) as count_events,
        min(occurred_at) as first_event_at,
        max(occurred_at) as last_event_at
        {% if guide_event_types | length > 0 %}
        , {{ dbt_utils.pivot(column='type', values=guide_event_types,
                            prefix='count_visitors_', agg='count', then_value='visitor_id', else_value='null', distinct=true) }}
        {% endif %}

    from guide_event
    group by 1,2

)

select *
from calculate_metrics