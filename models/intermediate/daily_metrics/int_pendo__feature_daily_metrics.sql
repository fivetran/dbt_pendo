{{ config(enabled=false) }}

{# with feature_event as (

    select 
        *,
        cast( {{ dbt_utils.date_trunc('day', 'occurred_at') }} as date) as occurred_on

    from {{ var('feature_event') }}

),
 #}
