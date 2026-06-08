with visitor_account_history as (

    select *
    from {{ ref('stg_pendo__visitor_account_history') }}

),

latest_visitor_account as (
    select
      *,
      row_number() over(partition by visitor_id, account_id {{ fivetran_utils.partition_by_source_relation(package_name='pendo') }} order by visitor_last_updated_at desc) as latest_visitor_account_index
    from visitor_account_history
)

select *
from latest_visitor_account
where latest_visitor_account_index = 1