-- It is important that you have executed the main queries from adding_training_data.sql
-- Worksheet name: Adding Training Data (Semantic Layer)

create or replace table raw.jaffle_shop.customers_alt (
    id varchar,
    name varchar
);

create or replace table raw.jaffle_shop.orders_alt (
    id varchar,
    customer varchar,
    ordered_at timestamp,
    store_id varchar,
    subtotal int,
    tax_paid int,
    order_total int
);

create or replace table raw.jaffle_shop.items (
    id varchar,
    order_id varchar,
    sku varchar
);

create or replace table raw.jaffle_shop.products (
    sku varchar,
    name varchar,
    type varchar,
    price int,
    description varchar
);

create or replace table raw.jaffle_shop.stores (
    id varchar,
    name varchar,
    opened_at datetime,
    tax_rate int
);

create or replace table raw.jaffle_shop.supplies (
    id varchar,
    name varchar,
    cost int,
    perishable boolean,
    sku varchar
);

copy into raw.jaffle_shop.customers_alt (id, name)
from 's3://dbt-learn-sample-data/raw_customers.csv'
file_format = (  
    type = 'CSV' 
    field_delimiter = ',' 
    skip_header = 1
);

copy into raw.jaffle_shop.orders_alt (id, customer, ordered_at, store_id, subtotal, tax_paid, order_total)
from 's3://dbt-learn-sample-data/raw_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.jaffle_shop.items (id, order_id, sku)
from 's3://dbt-learn-sample-data/raw_items.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.jaffle_shop.products (sku, name, type, price, description)
from 's3://dbt-learn-sample-data/raw_products.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.jaffle_shop.stores(id, name, opened_at, tax_rate)
from 's3://dbt-learn-sample-data/raw_stores.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

copy into raw.jaffle_shop.supplies (id, name, cost, perishable, sku)
from 's3://dbt-learn-sample-data/raw_supplies.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
);

select * from raw.jaffle_shop.customers_alt limit 10;
select * from raw.jaffle_shop.orders_alt limit 10;
select * from raw.jaffle_shop.items limit 10;
select * from raw.jaffle_shop.products limit 10;
select * from raw.jaffle_shop.stores limit 10;
select * from raw.jaffle_shop.supplies limit 10;
