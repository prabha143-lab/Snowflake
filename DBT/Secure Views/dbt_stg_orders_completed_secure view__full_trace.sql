# models/staging/sources.yml

version: 2

sources:
  - name: raw
    schema: public         # Replace with actual schema
    database: mysnow    # Optional if using default target
    tables:
      - name: orders


***********************************************************

{{ 
    config(
        materialized='view',
        secure=true
    ) 
}}

-- ❓ Purpose: Create a view for completed orders

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM {{ source('raw', 'orders') }}
WHERE order_status = 'completed'


***************************************************************

07:28:53 1 of 1 START sql view model dbt_pk.dbt_stg_orders_completed_secure_view__full_trace  [RUN]
07:28:53 1 of 1 OK created sql view model dbt_pk.dbt_stg_orders_completed_secure_view__full_trace  [[32mSUCCESS 1[0m in 0.47s]


07:28:53 Began running node model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace
07:28:53 1 of 1 START sql view model dbt_pk.dbt_stg_orders_completed_secure_view__full_trace  [RUN]
07:28:53 Began compiling node model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace
07:28:53 Writing injected SQL for node "model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace"
07:28:53 Began executing node model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace
07:28:53 Writing runtime sql for node "model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace"
07:28:53 Using snowflake connection "model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace"
07:28:53 On model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace: create or replace secure  view MYSNOW.dbt_pk.dbt_stg_orders_completed_secure_view__full_trace
  
  
  
  
  as (
    

-- ❓ Purpose: Create a view for completed orders

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM mysnow.public.orders
WHERE order_status = 'completed'
  )
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace"} */;
07:28:53 SQL status: SUCCESS 1 in 0.421 seconds
07:28:53 1 of 1 OK created sql view model dbt_pk.dbt_stg_orders_completed_secure_view__full_trace  [[32mSUCCESS 1[0m in 0.47s]
07:28:53 Finished running node model.my_new_project.dbt_stg_orders_completed_secure_view__full_trace


***********************Snowflake output*************

SELECT * FROM MYSNOW.dbt_pk.dbt_stg_orders_completed_secure_view__full_trace;

ORDER_ID	CUSTOMER_ID	ORDER_DATE	TOTAL_AMOUNT
1001	C001	2023-10-01	250.00
1003	C003	2023-10-03	320.00