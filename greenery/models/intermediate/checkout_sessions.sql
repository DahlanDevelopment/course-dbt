
{{
  config(
    materialized = 'table'
  )
}}

with events as (
  select * from {{ ref('stg_events') }}
)

, checkout_sessions_table as (
  select
    
    session_id
    , sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts
    , min(created_at) as first_session_event_at_utc
    , max(created_at) as last_session_event_at_utc
  from events
  group by 1
)

select * from checkout_sessions_table