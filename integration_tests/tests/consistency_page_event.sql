{% set exclude_cols = ['_fivetran_synced'] + var('consistency_test_exclude_metrics', ['source_relation']) %}

-- this test ensures the pendo__page_event end model matches the prior version
with prod as (
    select {{ dbt_utils.star(from=ref('pendo__page_event'), except=exclude_cols) }}
    from {{ target.schema }}_pendo_prod.pendo__page_event
),

dev as (
    select {{ dbt_utils.star(from=ref('pendo__page_event'), except=exclude_cols) }}
    from {{ target.schema }}_pendo_dev.pendo__page_event
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final