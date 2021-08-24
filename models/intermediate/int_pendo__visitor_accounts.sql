with visitor_account as (

    select *
    from {{ ref('int_pendo__latest_visitor_account') }}
),

account as (

    select *
    from {{ ref('int_pendo__latest_account') }}
),

agg_accounts as (
    
    select 
        visitor_account.visitor_id,
        count(distinct visitor_account.account_id) as count_accounts,
        {{ fivetran_utils.string_agg('account.account_name',  "', '") }} as accounts

    from visitor_account
    left join account 
        on visitor_account.account_id = account.account_id

    group by 1
)

select *
from agg_accounts