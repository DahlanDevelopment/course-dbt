{{config(MATERIALIZED = 'table')}}
with session_events_agg as (
        SELECT *
        FROM
{{ref('int_session_events_agg')}}
    ),
    users as (
        SELECT *
        FROM
{{ref('stg_postgres_users')}}
    )
SELECT
    session_events_agg.session_guid,
    users.first_name,
    users.last_name,
    users.email,
    session_events_agg.page_views,
    session_events_agg.add_to_carts,
    session_events_agg.checkouts,
    session_events_agg.package_shipped,
    session_events_agg.first_session_event_at_utc as first_session_event,
    session_events_agg.last_session_event_at_utc as last_session_event,
    datediff(
        'minute',
        first_session_event,
        last_session_event
    ) as session_length_minutes
FROM session_events_agg
    LEFT JOIN users ON session_events_agg.user_guid = users.user_guid