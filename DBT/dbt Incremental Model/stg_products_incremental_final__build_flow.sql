create or replace table products (
  id integer,
  name string,
  price number(10,2)
);

insert into products (id, name, price) values
  (1, 'Mouse', 25.00),
  (2, 'Keyboard', 45.00);


*************************************************************

# models/staging/sources.yml

version: 2

sources:
  - name: raw
    schema: public
    database: mysnow
    description: Raw source for customer orders

    tables:
      - name: orders
        description: Customer order transactions

        columns:
          - name: order_id
            tests: [not_null, unique]

          - name: order_date
            tests: [not_null]
        
      - name: products
        description: Product catalog and availability


*************************************************************

--models/staging/stg_products_incremental_final.sql
{{ config(
    materialized='incremental',
    unique_key='id'
) }}

select
  id,
  name,
  price
from {{ source('raw', 'products') }}

{% if is_incremental() %}
  where id not in (select id from {{ this }})
{% endif %}


***************************************************************
dbt run --select stg_products_incremental_final



SELECT * FROM MYSNOW.dbt_pk.stg_products_incremental_final;

ID	NAME	PRICE
1	Mouse	25.00
2	Keyboard	45.00



insert into products (id, name, price) values (3, 'USB-C Hub', 55.00);

dbt run --select stg_products_incremental_final

SELECT * FROM MYSNOW.dbt_pk.stg_products_incremental_final;

ID	NAME	PRICE
3	USB-C Hub	55.00
1	Mouse	25.00
2	Keyboard	45.00


create or replace  temporary view MYSNOW.dbt_pk.stg_products_incremental_final__dbt_tmp

SELECT * FROM MYSNOW.dbt_pk.stg_products_incremental_final__dbt_tmp;

SQL compilation error: Object 'MYSNOW.DBT_PK.STG_PRODUCTS_INCREMENTAL_FINAL__DBT_TMP' does not exist or not authorized.


What Is __dbt_tmp?
It’s a temporary table created by dbt during the incremental model build.

dbt uses it to stage new data before merging it into the target table.

The full flow:

dbt creates stg_products_incremental_final__dbt_tmp

Loads new rows into it

Merges into stg_products_incremental_final

Drops the __dbt_tmp table