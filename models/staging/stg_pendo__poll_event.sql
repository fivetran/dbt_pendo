
with base as (

    select * 
    from {{ ref('stg_pendo__poll_event_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pendo__poll_event_tmp')),
                staging_columns=get_poll_event_columns()
            )
        }}
        {{ pendo.apply_source_relation() }}
        
    from base
),

final as (
    
    select
        source_relation,
        account_id,
        app_id,
        country,
        guide_id,
        guide_step_id,
        latitude,
        longitude,
        poll_id,
        poll_response,
        region,
        remote_ip,
        server_name,
        timestamp as occurred_at,
        type,
        url,
        user_agent,
        visitor_id,
        _fivetran_synced,
        _fivetran_id,
        {{ dbt_utils.generate_surrogate_key(['source_relation', 'visitor_id', 'timestamp', 'account_id', 'server_name', 'poll_id', 'guide_id', 'user_agent', 'remote_ip', '_fivetran_id']) }}
            as poll_event_key

    from fields
)

select * 
from final
