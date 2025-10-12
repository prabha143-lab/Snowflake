-- Stored Procedure: Load employee data from stage to employee_data2
CREATE OR REPLACE PROCEDURE sp_load_employee_data2()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    copy_status STRING;
BEGIN
    -- Load data using COPY INTO from staged compressed CSV
    COPY INTO employee_data2
    FROM @employee_data2/employee_data2.csv.gz
    FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE';  -- Optional: skip bad records

    -- Assign success message using := syntax
    copy_status := 'Data load completed into employee_data_final.';
    RETURN copy_status;
END;
$$;
