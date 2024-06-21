-- Those queries are specific for Snowflake
-- Worksheet name: Adding Training Data

use role accountadmin;
use warehouse compute_wh;

create database raw;
create database analytics;
create schema raw.jaffle_shop;
create schema raw.stripe;

create or replace table raw.jaffle_shop.customers (
    id integer,
    first_name varchar,
    last_name varchar
);

create or replace table raw.jaffle_shop.orders (
    id integer,
    user_id integer,
    order_date date,
    status varchar,
    _etl_loaded_at timestamp default current_timestamp
);

create or replace table raw.stripe.payment (
    id integer,
    orderid integer,
    paymentmethod varchar,
    status varchar,
    amount integer,
    created date,
    _batched_at timestamp default current_timestamp
);

copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

select * from raw.jaffle_shop.customers limit 10;
select * from raw.jaffle_shop.orders limit 10;
select * from raw.stripe.payment limit 10;

-- Querying those models

use role accountadmin;
use warehouse compute_wh;
use database analytics;

select * from raw.jaffle_shop.customers limit 10;
select * from raw.jaffle_shop.orders limit 10;
select * from raw.stripe.payment limit 10;

select * from raw.jaffle_shop.customers_alt limit 10;
select * from raw.jaffle_shop.orders_alt limit 10;
select * from raw.jaffle_shop.items limit 10;
select * from raw.jaffle_shop.products limit 10;
select * from raw.jaffle_shop.stores limit 10;
select * from raw.jaffle_shop.supplies limit 10;

select * from dev.my_first_dbt_model limit 10;
select * from dev.my_second_dbt_model limit 10;

select * from dev.stg_jaffle_shop__customers limit 10;
select * from dev.stg_jaffle_shop__orders limit 10;
select * from dev.stg_stripe__payment limit 10;

select * from dev.dim_customers limit 10;
select * from dev.fct_orders limit 10;

----------
select * from dev.customers_orders limit 10;
select * from dev.new_customers_orders limit 10;

----------
select * from dev.stg_customers_alt limit 10;
select * from dev.stg_order_items limit 10;
select * from dev.stg_orders_alt limit 10;
select * from dev.stg_products limit 10;
select * from dev.stg_supplies limit 10;

select * from dev.dim_customers_alt limit 10;
select * from dev.fct_orders_alt limit 10;
select * from dev.order_items limit 10;
