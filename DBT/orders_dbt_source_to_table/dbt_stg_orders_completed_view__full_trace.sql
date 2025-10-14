# models/staging/sources.yml

version: 2

sources:
  - name: raw
    schema: public         # Replace with actual schema
    database: mysnow    # Optional if using default target
    tables:
      - name: orders



******************************************************************************

models/staging/stg_orders_completed_view.sql


{{ 
    config(
        materialized='view'
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


*****************************************System Logs**************************

06:53:46 On model.my_new_project.stg_orders_completed_view: create or replace   view MYSNOW.dbt_pk.stg_orders_completed_view
  
  
  
  
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
  
  
****************Output in Snowflake ***************************************

SELECT * FROM MYSNOW.dbt_pk.stg_orders_completed_view;

ORDER_ID	CUSTOMER_ID	ORDER_DATE	TOTAL_AMOUNT
1001	C001	2023-10-01	250.00
1003	C003	2023-10-03	320.00