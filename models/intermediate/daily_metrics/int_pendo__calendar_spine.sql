{{
    config(
        materialized='incremental',
        partition_by = {'field': 'date_day', 'data_type': 'date'}
            if target.type != 'spark' else ['date_day'],
        unique_key='date_day',
        incremental_strategy = 'merge',
        file_format = 'delta'
    )
}}

with spine as (

    {% if execute %}
    {% set first_date_query %}
    -- start at the first event
        select  min( created_at ) as min_date from {{ source('pendo','application_history') }}
    {% endset %}
    {% set first_date = run_query(first_date_query).columns[0][0]|string %}
    
    {% else %} {% set first_date = "2016-01-01" %}
    {% endif %}


    select * 
    from (
        {{
            dbt_utils.date_spine(
                datepart = "day", 
                start_date =  "2016-01-01", 
                end_date = dbt_utils.dateadd("week", 1, "current_date")
            )   
        }} 
    ) as date_spine

    {% if is_incremental() %}
    -- compare to the earliest possible open_until date so that if a resolved issue is updated after a long period of inactivity, we don't need a full refresh
    -- essentially we need to be able to backfill
    where date_day >= (select max(date_day) from {{ this }} )
    {% endif %}
)

select 
    cast(date_day as date) as date_day
from spine