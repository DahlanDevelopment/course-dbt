SELECT 1;

WITH orders_cohort AS (
    SELECT user_id
    , COUNT(DISTINCT order_id) AS user_orders
    FROM DEV_DB.DBT_SHARIFFDAHLAN.STG_POSTGRES_ORDERS
    GROUP BY 1
)
, users_bucket AS (
    SELECT
        user_id
        , (user_orders = 1)::INT AS has_one_purchases
        , (user_orders = 2)::INT AS has_two_purchases
        , (user_orders = 3)::INT AS has_three_purchases
        , (user_orders >= 2)::INT AS has_two_plus_purchases
        FROM orders_cohort
)

SELECT
SUM(has_one_purchases) AS one_purchase
, SUM(has_two_purchases) AS two_purchases
, SUM(has_three_purchases) AS three_purchases
, SUM(has_two_plus_purchases) AS two_plus_purchases
, COUNT(DISTINCT user_id) AS num_users_w_purchase
, DIV0(two_plus_purchases, num_users_w_purchase) as repeat_rate
FROM users_bucket