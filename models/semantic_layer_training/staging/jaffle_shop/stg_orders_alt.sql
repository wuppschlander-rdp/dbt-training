{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
    )
}}

select
    id as order_id,
    store_id as location_id,
    customer as customer_id,
    (order_total / 100.0) as order_total,
    (tax_paid / 100.0) as tax_paid,
    ordered_at
from
    {{ source('jaffle_shop', 'orders_alt') }}
