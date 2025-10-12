-- Stored Procedure: Load employee data from stage to employee_data2
CREATE OR REPLACE PROCEDURE sp_load_employee_data2_snowpipe_test()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    pipe_status STRING;
BEGIN
    CREATE OR REPLACE PIPE employee_data2_pipe_test
    AUTO_INGEST = FALSE
    AS
    COPY INTO employee_data2_snowpipe_test
    FROM @employee_data2_snowpipe_test/employee_data2_snowpipe_test.csv.gz
    FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
    ON_ERROR = 'CONTINUE';  -- Optional: skip bad records
    
	--ALTER PIPE employee_data2_pipe REFRESH;
	
    -- Assign success message using := syntax
    pipe_status := 'Data load completed into employee_data2_pipe.';
    RETURN pipe_status;
END;
$$;
