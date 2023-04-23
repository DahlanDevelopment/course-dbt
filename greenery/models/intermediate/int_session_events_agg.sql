{{
    config(
        MATERIALIZED = 'table'
    )
}}

WITH events AS (
    SELECT * FROM {{'stg_postgres_events'}}
)

, final AS (
    user_id as user_guid
    , session_guid
    , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart
    , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout
    , SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped
    , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS page_view
    , MIN(created_at) AS first_session_event_at_utc
    , MAX(created_at) AS last_session_event_at_utc
    FROM events
    GROUP BY 1,2
)

SELECT * FROM final