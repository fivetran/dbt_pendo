with feature as (

    select 
        {{ dbt_utils.star(from=ref('int_pendo__latest_feature'), except='LATEST_FEATURE_INDEX' if target.type == 'snowflake' else 'latest_feature_index') }}

    from {{ ref('int_pendo__latest_feature') }}
),

pendo_user as (

    select *
    from {{ var('user') }}

),

page as (

    select *
    from {{ ref('int_pendo__latest_page') }}

),

application as (

    select *
    from {{ ref('int_pendo__latest_application') }}

),

product_area as (

    select *
    from {{ var('group') }}

),

feature_join as (

    select 
        feature.*,
        product_area.group_name as product_area_name,
        page.page_name,
        page.created_at as page_created_at,
        application.display_name as app_display_name,
        application.platform as app_platform,
        pendo_user.first_name || ' ' || pendo_user.last_name as created_by_user_full_name,
        pendo_user.username as created_by_user_username

    from feature
    left join page
        on feature.page_id = page.page_id
    left join product_area
        on feature.group_id = product_area.group_id
    left join application 
        on feature.app_id = application.application_id
    left join pendo_user 
        on feature.created_by_user_id = pendo_user.user_id 
)

select *
from feature_join