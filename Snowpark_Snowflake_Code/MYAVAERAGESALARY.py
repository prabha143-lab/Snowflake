CREATE OR REPLACE PROCEDURE MYSNOW.PUBLIC.MYAVAERAGESALARY()
RETURNS TABLE ()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'main'
EXECUTE AS OWNER
AS 'from snowflake.snowpark.functions import col, avg

def main(session):
    # Step 1: Read the existing table
    df = session.table("employees123")

    # Step 2: Filter Engineering employees
    engineering_emps = df.filter(col("DEPARTMENT") == "Engineering")

    # Step 3: Average salary by department
    avg_salary = df.group_by("DEPARTMENT").agg(avg("SALARY").alias("AVG_SALARY"))

    # Step 4: Add bonus column (10% of salary)
    df_with_bonus = df.with_column("BONUS", col("SALARY") * 0.10)

    # Step 5: Return final DataFrame (Snowflake will display this)
    return df_with_bonus
';