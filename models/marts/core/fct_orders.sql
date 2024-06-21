with orders_amount as (
    select
        order_id,
        sum(amount) as amount
    from
        {{ ref('stg_stripe__payment') }}
    where
        status = 'success'
    group by
        order_id
),

orders as (
    select
        order_id,
        customer_id,
        order_date
    from
        {{ ref('stg_jaffle_shop__orders') }}
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders_amount.amount
    from
        orders
        left join orders_amount using (order_id)
)

select * from final
