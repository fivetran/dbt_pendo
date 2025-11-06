with poll as (

    select *
    from {{ ref('stg_pendo__poll') }}

    where lower(attribute_type) = 'npsrating'

),

poll_event as (

    select *
    from {{ ref('stg_pendo__poll_event') }}
),

limit_to_nps_polls as (

    select
        poll_event.*

    from poll_event
    join poll
        on poll_event.source_relation = poll.source_relation
        and poll_event.poll_id = poll.poll_id
),

order_responses as (

    select
        *,
        row_number() over(partition by visitor_id {{ pendo.partition_by_source_relation() }} order by occurred_at desc) as latest_response_index
    from limit_to_nps_polls
),

latest_response as (

    select
        source_relation,
        visitor_id,
        account_id,
        cast(poll_response as {{ dbt.type_int() }}) as nps_rating

    from order_responses
    where latest_response_index = 1

)

select *
from latest_response