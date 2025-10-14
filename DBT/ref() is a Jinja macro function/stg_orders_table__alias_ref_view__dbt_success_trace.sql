# models/staging/sources.yml

version: 2

sources:
  - name: raw
    schema: public         # Replace with actual schema
    database: mysnow    # Optional if using default target
    tables:
      - name: orders


***************************************************************
models/staging/stg_orders_table_alias_ref.sql



SELECT * FROM {{ ref('stg_orders_table') }}


************************************************************
07:47:26 1 of 1 START sql view model dbt_pk.stg_orders_table_alias_ref .................. [RUN]
07:47:26 1 of 1 OK created sql view model dbt_pk.stg_orders_table_alias_ref ............. [[32mSUCCESS 1[0m in 0.39s]




07:47:26 Began running node model.my_new_project.stg_orders_table_alias_ref
07:47:26 1 of 1 START sql view model dbt_pk.stg_orders_table_alias_ref .................. [RUN]
07:47:26 Began compiling node model.my_new_project.stg_orders_table_alias_ref
07:47:26 Writing injected SQL for node "model.my_new_project.stg_orders_table_alias_ref"
07:47:26 Began executing node model.my_new_project.stg_orders_table_alias_ref
07:47:26 Writing runtime sql for node "model.my_new_project.stg_orders_table_alias_ref"
07:47:26 Using snowflake connection "model.my_new_project.stg_orders_table_alias_ref"
07:47:26 On model.my_new_project.stg_orders_table_alias_ref: create or replace   view MYSNOW.dbt_pk.stg_orders_table_alias_ref
  
  
  
  
  as (
    SELECT * FROM MYSNOW.dbt_pk.stg_orders_table
  )
/* {"app": "dbt", "dbt_version": "2025.10.10+79ec687", "profile_name": "user", "target_name": "default", "node_id": "model.my_new_project.stg_orders_table_alias_ref"} */;
07:47:26 SQL status: SUCCESS 1 in 0.339 seconds
07:47:26 1 of 1 OK created sql view model dbt_pk.stg_orders_table_alias_ref ............. [[32mSUCCESS 1[0m in 0.39s]
07:47:26 Finished running node model.my_new_project.stg_orders_table_alias_ref



**********************************************************

SELECT * FROM MYSNOW.dbt_pk.stg_orders_table_alias_ref;


ORDER_ID	CUSTOMER_ID	ORDER_DATE	TOTAL_AMOUNT
1001	C001	2023-10-01	250.00
1003	C003	2023-10-03	320.00