Perfect! Let’s walk through a complete 5-step Snowflake + Airflow pipeline, using realistic data and showing how each step transforms it.
This will simulate a retail sales pipeline for a company operating across Europe.

🧩 Step 1: Load Raw Sales Data into Snowflake

🔹 Source: external_source (staging table)
sql
-- Sample data in external_source
+----------+------------+------------+--------+
| store_id | product_id | sale_date  | amount |
+----------+------------+------------+--------+
| 101      | A1         | 2025-09-27 | 100.00 |
| 102      | B2         | 2025-09-27 | 150.00 |
| 101      | A1         | NULL       | 120.00 |
| 103      | C3         | 2025-09-27 | NULL   |
+----------+------------+------------+--------+

🔹 Airflow Task

python
load_sales = SnowflakeOperator(
    task_id='load_sales_data',
    sql="""
        INSERT INTO raw.sales_data
        SELECT * FROM external_source;
    """,
    snowflake_conn_id='snowflake_conn'
)


🧼 Step 2: Clean and Transform with dbt
🔹 dbt Model: cleaned_sales.sql
sql
SELECT
    store_id,
    product_id,
    sale_date,
    amount
FROM {{ ref('raw_sales_data') }}
WHERE sale_date IS NOT NULL AND amount IS NOT NULL;

🔹 Output: cleaned_sales
sql
+----------+------------+------------+--------+
| store_id | product_id | sale_date  | amount |
+----------+------------+------------+--------+
| 101      | A1         | 2025-09-27 | 100.00 |
| 102      | B2         | 2025-09-27 | 150.00 |
+----------+------------+------------+--------+

🔹 Airflow Task
python
run_dbt = PythonOperator(
    task_id='run_dbt_models',
    python_callable=run_dbt_function
)


📊 Step 3: Calculate KPIs in Snowflake
🔹 Stored Procedure: calculate_daily_kpis()
sql
CREATE OR REPLACE PROCEDURE calculate_daily_kpis()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO analytics.daily_kpis
    SELECT
        CURRENT_DATE AS report_date,
        COUNT(DISTINCT store_id) AS active_stores,
        SUM(amount) AS total_sales
    FROM cleaned_sales
    WHERE sale_date = CURRENT_DATE;
    RETURN 'KPIs calculated';
END;
$$;
🔹 Output: analytics.daily_kpis
sql
+-------------+---------------+-------------+
| report_date | active_stores | total_sales |
+-------------+---------------+-------------+
| 2025-09-27  | 2             | 250.00      |
+-------------+---------------+-------------+

🔹 Airflow Task
python
calc_kpis = SnowflakeOperator(
    task_id='calculate_kpis',
    sql='CALL calculate_daily_kpis();',
    snowflake_conn_id='snowflake_conn'
)


📤 Step 4: Export KPIs (Simulated)
🔹 Python Function
python
def export_kpis():
    print("Exporting KPIs to dashboard or emailing report...")
🔹 Airflow Task
python
export_results = PythonOperator(
    task_id='export_kpis',
    python_callable=export_kpis
)


📣 Step 5: Notify via Slack (Simulated)
🔹 Python Function
python
def notify_slack():
    print("Slack alert: Daily sales pipeline completed successfully.")
🔹 Airflow Task
python
notify_slack = PythonOperator(
    task_id='notify_slack',
    python_callable=notify_slack
)



🔗 DAG Flow Summary
python
load_sales >> run_dbt >> calc_kpis >> export_results >> notify_slack
This pipeline ensures:

Clean, validated data

Automated KPI reporting

Team visibility via Slack