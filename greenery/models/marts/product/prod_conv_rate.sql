{{
    config(
        materialized='table'
        , post_hook=["grant select on {{ this }} to role reporting"]
    )
}}

with product_conversion as (

{{ conversion_rate(ref('events_agg'),'PRODUCT_ID','PURCHASE','PAGE_VIEWS') }}


)
select 
product_id
, numerator as purchases
, denom as views
, conversion as product_conversion 
from product_conversion