with page as (

    select *
    from {{ ref('int_pendo__latest_page') }}
),

application as (

    select *
    from {{ ref('int_pendo__latest_application') }}
),

pendo_user as (

    select *
    from {{ var('user') }}
),

product_area as (

    select *
    from {{ var('group') }}
),

page_rule as (

    select *
    from {{ ref('int_pendo__latest_page_rule') }}
),

agg_page_rule as (

    select 
        page_id,
        -- should we use a different/more apparent delimiter?
        {{ fivetran_utils.string_agg( "rule", "', '" ) }} as rules 
        
    from page_rule
    group by 1
),

page_join as (

    select 
        page.*,
        agg_page_rule.rules,
        product_area.group_name as product_area_name,
        application.display_name as app_display_name,
        application.platform as app_platform,
        creator.first_name || ' ' || creator.last_name as created_by_user_full_name,
        creator.username as created_by_user_username,
        updater.first_name || ' ' || updater.last_name as last_updated_by_user_full_name,
        updater.username as last_updated_by_user_username

    from page 
    left join application 
        on page.app_id = application.application_id
    left join pendo_user as creator
        on page.created_by_user_id = creator.user_id 
    left join pendo_user as updater
        on page.last_updated_by_user_id = updater.user_id
    left join product_area
        on page.group_id = product_area.group_id 
    left join agg_page_rule
        on page.page_id = agg_page_rule.page_id

)

select *
from page_join