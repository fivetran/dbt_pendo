
with base as (

    select * 
    from {{ ref('stg_pendo__group_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pendo__group_tmp')),
                staging_columns=get_group_columns()
            )
        }}
        {{ pendo.apply_source_relation() }}
        
    from base
),

final as (
    
    select
        source_relation,
        id as group_id,
        app_id,
        created_at,
        created_by_user_id,
        description,
        last_updated_at,
        last_updated_by_user_id,
        name as group_name,
        _fivetran_synced

    from fields
)

select * 
from final
