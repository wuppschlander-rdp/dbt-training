with customers as (
    select
        customer_id,
        first_name,
        last_name
    from
        {{ ref('stg_jaffle_shop__customers') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from
        {{ ref('fct_orders') }}
    group by
        customer_id
),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.lifetime_value, 0) as lifetime_value
    from
        customers
        left join customer_orders
            on customers.customer_id = customer_orders.customer_id
)

select * from final
