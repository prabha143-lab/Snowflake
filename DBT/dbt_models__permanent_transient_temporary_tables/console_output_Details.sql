06:39:27 Began running node model.my_new_project.stg_orders_table
06:39:27 1 of 1 START sql table model dbt_pk.stg_orders_table ........................... [RUN]
06:39:27 Began compiling node model.my_new_project.stg_orders_table
06:39:27 Writing injected SQL for node "model.my_new_project.stg_orders_table"
06:39:27 Began executing node model.my_new_project.stg_orders_table
06:39:27 Writing runtime sql for node "model.my_new_project.stg_orders_table"
06:39:27 Using snowflake connection "model.my_new_project.stg_orders_table"
06:39:27 On model.my_new_project.stg_orders_table: create or replace transient table MYSNOW.dbt_pk.stg_orders_table
    
    
    
    as (-- models/staging/stg_orders_table.sql
-- ❓ Purpose: Create a staging table for completed orders



SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM mysnow.public.orders
WHERE order_status = 'completed'
    )

/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "model.my_new_project.stg_orders_table"} */;
06:39:29 SQL status: SUCCESS 1 in 1.347 seconds
06:39:29 1 of 1 OK created sql table model dbt_pk.stg_orders_table ...................... [[32mSUCCESS 1[0m in 1.40s]
06:39:29 Finished running node model.my_new_project.stg_orders_table