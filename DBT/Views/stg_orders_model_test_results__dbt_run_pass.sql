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


*********************************************************************

-- models/staging/stg_orders.sql

{{ config(materialized='view') }}

SELECT
  order_id,
  customer_id,
  order_date,
  total_amount,
  order_status
FROM {{ source('raw', 'orders') }}


*********************************************************************

# models/staging/stg_orders.yml

version: 2

models:
  - name: stg_orders
    description: Staging model for raw.orders
    columns:
      - name: order_id
        tests: [not_null, unique]

      - name: order_date
        tests: [not_null]

*********************************************************************

dbt run --select stg_orders


08:14:46 1 of 1 START sql view model dbt_pk.stg_orders .................................. [RUN]
08:14:47 1 of 1 OK created sql view model dbt_pk.stg_orders ............................. [[32mSUCCESS 1[0m in 0.49s]


08:14:46 Began running node model.my_new_project.stg_orders
08:14:46 1 of 1 START sql view model dbt_pk.stg_orders .................................. [RUN]
08:14:46 Began compiling node model.my_new_project.stg_orders
08:14:46 Writing injected SQL for node "model.my_new_project.stg_orders"
08:14:46 Began executing node model.my_new_project.stg_orders
08:14:46 Writing runtime sql for node "model.my_new_project.stg_orders"
08:14:46 Using snowflake connection "model.my_new_project.stg_orders"
08:14:46 On model.my_new_project.stg_orders: create or replace   view MYSNOW.dbt_pk.stg_orders
  
  
  
  
  as (
    -- models/staging/stg_orders.sql



SELECT
  order_id,
  customer_id,
  order_date,
  total_amount,
  order_status
FROM mysnow.public.orders
  )
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "model.my_new_project.stg_orders"} */;
08:14:47 SQL status: SUCCESS 1 in 0.438 seconds
08:14:47 1 of 1 OK created sql view model dbt_pk.stg_orders ............................. [[32mSUCCESS 1[0m in 0.49s]
08:14:47 Finished running node model.my_new_project.stg_orders


**************************************************************************


dbt test --select stg_orders


not_null_stg_orders_order_date
not_null_stg_orders_order_id
unique_stg_orders_order_id




 not_null_stg_orders_order_date
 
 
 08:15:47 1 of 3 START test not_null_stg_orders_order_date ............................... [RUN]
08:15:48 1 of 3 PASS not_null_stg_orders_order_date ..................................... [[32mPASS[0m in 0.65s]

08:15:47 Began running node test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb
08:15:47 1 of 3 START test not_null_stg_orders_order_date ............................... [RUN]
08:15:47 Began compiling node test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb
08:15:47 Writing injected SQL for node "test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb"
08:15:47 Began executing node test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb
08:15:47 Writing runtime sql for node "test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb"
08:15:47 Using snowflake connection "test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb"
08:15:47 On test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb: select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_date
from MYSNOW.dbt_pk.stg_orders
where order_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb"} */
08:15:48 SQL status: SUCCESS 1 in 0.590 seconds
08:15:48 1 of 3 PASS not_null_stg_orders_order_date ..................................... [[32mPASS[0m in 0.65s]
08:15:48 Finished running node test.my_new_project.not_null_stg_orders_order_date.2177a3e8bb



***

not_null_stg_orders_order_id


08:15:47 2 of 3 START test not_null_stg_orders_order_id ................................. [RUN]
08:15:48 2 of 3 PASS not_null_stg_orders_order_id ....................................... [[32mPASS[0m in 1.45s]


08:15:47 Began running node test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64
08:15:47 2 of 3 START test not_null_stg_orders_order_id ................................. [RUN]
08:15:47 Acquiring new snowflake connection 'test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64'
08:15:47 Began compiling node test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64
08:15:47 Writing injected SQL for node "test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64"
08:15:47 Began executing node test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64
08:15:47 Writing runtime sql for node "test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64"
08:15:47 Using snowflake connection "test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64"
08:15:47 On test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64: select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_id
from MYSNOW.dbt_pk.stg_orders
where order_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64"} */
08:15:47 Opening a new connection, currently in state init
08:15:48 SQL status: SUCCESS 1 in 1.386 seconds
08:15:48 2 of 3 PASS not_null_stg_orders_order_id ....................................... [[32mPASS[0m in 1.45s]
08:15:48 Finished running node test.my_new_project.not_null_stg_orders_order_id.81cfe2fe64

********

unique_stg_orders_order_id

08:15:47 3 of 3 START test unique_stg_orders_order_id ................................... [RUN]
08:15:49 3 of 3 PASS unique_stg_orders_order_id ......................................... [[32mPASS[0m in 1.60s]


08:15:47 Began running node test.my_new_project.unique_stg_orders_order_id.e3b841c71a
08:15:47 3 of 3 START test unique_stg_orders_order_id ................................... [RUN]
08:15:47 Acquiring new snowflake connection 'test.my_new_project.unique_stg_orders_order_id.e3b841c71a'
08:15:47 Began compiling node test.my_new_project.unique_stg_orders_order_id.e3b841c71a
08:15:47 Writing injected SQL for node "test.my_new_project.unique_stg_orders_order_id.e3b841c71a"
08:15:47 Began executing node test.my_new_project.unique_stg_orders_order_id.e3b841c71a
08:15:47 Writing runtime sql for node "test.my_new_project.unique_stg_orders_order_id.e3b841c71a"
08:15:47 Using snowflake connection "test.my_new_project.unique_stg_orders_order_id.e3b841c71a"
08:15:47 On test.my_new_project.unique_stg_orders_order_id.e3b841c71a: select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    order_id as unique_field,
    count(*) as n_records

from MYSNOW.dbt_pk.stg_orders
where order_id is not null
group by order_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "test.my_new_project.unique_stg_orders_order_id.e3b841c71a"} */
08:15:47 Opening a new connection, currently in state init
08:15:49 SQL status: SUCCESS 1 in 1.541 seconds
08:15:49 3 of 3 PASS unique_stg_orders_order_id ......................................... [[32mPASS[0m in 1.60s]
08:15:49 Finished running node test.my_new_project.unique_stg_orders_order_id.e3b841c71a



************************OUTPUT**************************

SELECT * FROM MYSNOW.dbt_pk.stg_orders;

ORDER_ID	CUSTOMER_ID	ORDER_DATE	TOTAL_AMOUNT	ORDER_STATUS
1001	C001	2023-10-01	250.00	completed
1002	C002	2023-10-02	180.00	pending
1003	C003	2023-10-03	320.00	completed