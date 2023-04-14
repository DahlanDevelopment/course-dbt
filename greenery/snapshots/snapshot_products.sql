
{% snapshot snapshot_products %}
{{
  config(
    target_database = target.database,
    target_schema = target.schema,
    strategy='check',
    unique_key='product_guid',
    check_cols=['inventory'],
   )
}}

with base as (
    SELECT *
    FROM {{ref('stg_postgres_products')}}
)

SELECT * FROM base
{% endsnapshot %}