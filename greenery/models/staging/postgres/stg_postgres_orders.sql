{{
  config(
    materialized = 'table'
  )
}}

with source as (
  select * from {{ source('postgres', 'orders') }}
)

, renamed_recast as (
  select
    order_id
    , user_id
    , promo_id
    , address_id
    , order_cost
    , shipping_cost
    , order_total
    , shipping_service
    , estimated_delivery_at
    , delivered_at
    , status
    , created_at
  from source
)

select * from renamed_recast