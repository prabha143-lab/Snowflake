-- models/staging/stg_orders_table.sql
-- ❓ Purpose: Create a staging table for completed orders

{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount
FROM {{ source('raw', 'orders') }}
WHERE order_status = 'completed'
