***********************************************************************
📄 seeds/country_codes.csv

country_code,country_name
US,United States
IN,India
FR,France

Purpose: Static reference table of valid country codes used for validation.

***********************************************************************

📄 seeds/schema.yml

version: 2

seeds:
  - name: country_codes
    description: "Reference table for valid country codes"
    columns:
      - name: country_code
        description: "ISO country code"
        tests:
          - not_null      # Ensures every country_code is present
          - unique        # Ensures no duplicate country_code values
      - name: country_name
        description: "Full country name"
        tests:
          - not_null      # Ensures every country_name is present

Purpose: Validates seed data integrity using built-in dbt tests.

***********************************************************************

📄 models/customer_data.sql

-- Simulated model with customer country codes

SELECT *
FROM (
    SELECT 'US' AS country_code, 'Alice' AS customer_name
    UNION ALL
    SELECT 'IN', 'Ravi'
    UNION ALL
    SELECT 'XX', 'Unknown'  -- Invalid country code
) AS customers

Purpose: Simulates a model with customer data. Includes one invalid country code (XX) for testing.

***********************************************************************

📄 models/validate_country_codes.sql

-- Identifies country codes in customer_data that are not in the seed reference

SELECT
    c.country_code,
    c.customer_name
FROM {{ ref('customer_data') }} c
LEFT JOIN {{ ref('country_codes') }} s
  ON c.country_code = s.country_code
WHERE s.country_code IS NULL

Purpose: Flags any country codes in customer_data that are not found in the seed reference.

***********************************************************************

💻 dbt seed --select country_codes

> 📦 Loads the country_codes.csv seed file into your Snowflake warehouse.

📊 SELECT * FROM MYSNOW.dbt_pk.country_codes;

COUNTRY_CODE    COUNTRY_NAME
US              United States
IN              India
FR              France

***********************************************************************

💻 dbt run --select customer_data

> 🛠️ Builds the customer_data model in your warehouse.

📊 SELECT * FROM MYSNOW.dbt_pk.customer_data;

COUNTRY_CODE    CUSTOMER_NAME
US              Alice
IN              Ravi
XX              Unknown

***********************************************************************

💻 dbt run --select validate_country_codes

> 🛠️ Builds the validation model that compares customer_data against the seed.

📊 SELECT * FROM MYSNOW.dbt_pk.validate_country_codes;

COUNTRY_CODE    CUSTOMER_NAME
XX              Unknown

Output: Validation result. Flags XX as an invalid country code not found in the seed reference.

***********************************************************************
