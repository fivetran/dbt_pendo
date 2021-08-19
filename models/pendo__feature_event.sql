with feature_event as (

    select *
    from {{ var('feature_event') }}
),

feature as (

    select *
    from {{ ref('int_pendo__feature_info') }}
),

-- should we bring custom fields in from these? the default fields are not helpful to have but i could see 
-- users adding custom ones in (perhaps we leave that to them then..)
account as (

    select *
    from {{ ref('int_pendo__latest_account') }}
), 

visitor as (

    select *
    from {{ ref('int_pendo__latest_visitor') }}
),

add_previous_feature as (

    select 
        *,
        lag(feature_id) over(partition by visitor_id order by occurred_at asc, _fivetran_synced asc) as previous_feature_id,
        lag(occurred_at) over(partition by visitor_id order by occurred_at asc, _fivetran_synced asc) as previous_feature_event_at,
        lag(num_minutes) over(partition by visitor_id order by occurred_at asc, _fivetran_synced asc) as previous_feature_num_minutes

    from feature_event
), 

feature_event_join as (

    select
        add_previous_feature.*,
        
        current_feature.feature_name,
        current_feature.page_id,
        current_feature.page_name,
        current_feature.product_area_name,
        current_feature.group_id as product_area_id,

        previous_feature.feature_name as previous_feature_name,
        previous_feature.page_id as previous_feature_page_id,
        previous_feature.page_name as previous_feature_page_name,
        previous_feature.product_area_name as previous_feature_product_area_name,
        previous_feature.group_id as previous_feature_product_area_id,
        visitor.account_id as visitor_account_id -- this can be different from the event.account_id if the visitor is associated with multiple accounts

        {{ persist_pass_through_columns('pendo__account_history_pass_through_columns') }}
        {{ persist_pass_through_columns('pendo__visitor_history_pass_through_columns') }}

    from add_previous_feature
    join feature as current_feature
        on add_previous_feature.feature_id = current_feature.feature_id 
    left join feature as previous_feature 
        on add_previous_feature.previous_feature_id = previous_feature.feature_id

{% if var('pendo__visitor_history_pass_through_columns') %}
    left join visitor 
        on visitor.visitor_id = add_previous_feature.visitor_id
{% endif %}

{% if var('pendo__account_history_pass_through_columns') %}
    left join account
        on account.account_id = add_previous_feature.account_id
{% endif %}
)


select *
from feature_event_join
order by occurred_at desc