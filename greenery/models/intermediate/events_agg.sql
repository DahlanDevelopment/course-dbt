{{
  config(
    materialized = 'table'
  )
}}

with events as (
  select * from {{ ref('stg_events') }}
)
, checkout_sessions as (
    select
    session_id as ch_session_id
    , checkouts
    from {{ ref('checkout_sessions') }}
)
, agg_table as (
  select
    product_id
    , ch_session_id
    , min(checkouts) as checkout
    , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts
    , sum(case when event_type = 'add_to_cart' and checkouts=1 then 1 else 0 end) as purchase
    , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
    
  from events
  join checkout_sessions
  on events.session_id = checkout_sessions.ch_session_id
  group by 1,2
  having product_id is not null
)

select * from agg_table