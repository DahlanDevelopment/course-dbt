{{config(MATERIALIZED = 'table')}}
WITH events AS (
        SELECT *
        FROM
{{ref('stg_postgres_events')}}
    ),
    final AS (
        SELECT
            user_guid AS user_guid,
            session_guid,
            SUM(
                CASE
                    WHEN event_type = 'add_to_cart' THEN 1
                    ELSE 0
                END
            ) AS add_to_carts,
            SUM(
                CASE
                    WHEN event_type = 'checkout' THEN 1
                    ELSE 0
                END
            ) AS checkouts,
            SUM(
                CASE
                    WHEN event_type = 'package_shipped' THEN 1
                    ELSE 0
                END
            ) AS package_shipped,
            SUM(
                CASE
                    WHEN event_type = 'page_view' THEN 1
                    ELSE 0
                END
            ) AS page_views,
            MIN(created_at) AS first_session_event_at_utc,
            MAX(created_at) AS last_session_event_at_utc
        FROM events
        GROUP BY 1, 2
    )
SELECT *
FROM final