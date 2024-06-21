{% snapshot snap_orders %}
    {{
        config(
            target_database='analytics',
            target_schema=target.schema + '_snapshots',
            unique_key='order_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from {{ ref('stg_jaffle_shop__orders') }}

 {% endsnapshot %}
