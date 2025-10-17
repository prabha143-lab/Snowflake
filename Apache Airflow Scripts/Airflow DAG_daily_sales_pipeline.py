Real-World Example: Retail Sales Pipeline
Imagine a retail company with stores across Europe. Here's how Airflow orchestrates a Snowflake-based pipeline:

🔄 DAG: daily_sales_pipeline
Extract Data from API

Pull daily sales data from a POS system via REST API.

Load to Snowflake

Use Airflow’s SnowflakeOperator to insert raw data into raw.sales_data.

Run dbt Models

Trigger dbt transformations to clean and aggregate sales data.

Run Snowflake Stored Procedure

Execute a stored procedure to calculate KPIs like revenue per store.

Generate Report

Export results to a dashboard or email summary.

Send Slack Alert

Notify the team that the pipeline succeeded or failed.



*************** DAG Code Snippet (Simplified) ***********************************

from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago

with DAG('daily_sales_pipeline', start_date=days_ago(1), schedule_interval='@daily') as dag:

    load_sales = SnowflakeOperator(
        task_id='load_sales_data',
        sql='INSERT INTO raw.sales_data SELECT * FROM external_source;',
        snowflake_conn_id='snowflake_conn'
    )

    run_dbt = PythonOperator(
        task_id='run_dbt_models',
        python_callable=run_dbt_function
    )

    calc_kpis = SnowflakeOperator(
        task_id='calculate_kpis',
        sql='CALL calculate_daily_kpis();',
        snowflake_conn_id='snowflake_conn'
    )

    load_sales >> run_dbt >> calc_kpis
