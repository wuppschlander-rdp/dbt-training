{{
    config(
        materialized='table'
    )
}}

with orders as (
    select
        order_id,
        customer_id,
        order_date as order_placed_at,
        status as order_status,
        
        min(order_date) over (
            partition by customer_id
        ) as first_order_date,

        row_number() over (
            order by order_id
        ) as transaction_seq,

        row_number() over (
            partition by customer_id
            order by order_id
        ) as customer_sales_seq,

        /*
            This logic might be wrong in case the customer
            makes more than one order in the same day
            they made their first order
        */
        iff(
            order_date = first_order_date,
            'new',
            'return'
        ) as nvsr
    from
        {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select
        order_id,
        max(created_at) as payment_finalized_date,
        sum(amount) as total_amount_paid
    from
        {{ ref('stg_stripe__payment') }}
    where
        status <> 'fail'
    group by
        order_id
),

customers as (
    select
        customer_id,
        first_name as customer_first_name,
        last_name as customer_last_name
    from
        {{ ref('stg_jaffle_shop__customers') }}
),

final as (
    select
        orders.customer_id,
        orders.order_id,
        orders.order_placed_at,
        orders.order_status,
        payments.total_amount_paid,
        payments.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name,
        orders.transaction_seq,
        orders.customer_sales_seq,
        orders.nvsr,
        
        sum(total_amount_paid) over (
            partition by orders.customer_id
            order by orders.order_id asc
        ) as customer_lifetime_value,
        
        orders.first_order_date as fdos
    from
        orders
        left join payments using (order_id)
        left join customers using (customer_id)
    order by
        orders.order_id
)

select * from final
