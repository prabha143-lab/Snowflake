CREATE OR REPLACE DYNAMIC TABLE daily_sales_summary
  TARGET_LAG = '10 minutes'
  WAREHOUSE = TRANSFORMING_WH
AS
  SELECT
    DATE(sale_timestamp) AS sale_date,
    SUM(amount) AS total_sales,
    COUNT(DISTINCT customer_id) AS distinct_customers
  FROM raw_sales_data
  GROUP BY 1;