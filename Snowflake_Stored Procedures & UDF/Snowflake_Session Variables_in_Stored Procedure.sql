-- Step 1: Set the session variable in your session
SET MY_VAR1 = 'Hello from session variable';

-- Step 2: Create the stored procedure with EXECUTE AS CALLER to access the session variable
CREATE OR REPLACE PROCEDURE use_session_var()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
  val STRING;
BEGIN
  val := $MY_VAR1;  -- Access the session variable MY_VAR
  RETURN val;
END;
$$;

-- Step 3: Call the stored procedure to get the session variable value
CALL use_session_var();

--Hello from session variable


***********************************************************

-- Step 1: Set the session variable in your session
SET MY_VAR2 = 'Hello from session variable';

-- Step 2: Create the stored procedure with EXECUTE AS CALLER to access the session variable
CREATE OR REPLACE PROCEDURE use_session_var()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS
$$
DECLARE
  val STRING;
BEGIN
  val := $MY_VAR2;  -- Access the session variable MY_VAR
  RETURN val;
END;
$$;

-- Step 3: Call the stored procedure to get the session variable value
CALL use_session_var();

--Uncaught exception of type 'EXPRESSION_ERROR' on line 5 at position 9 : Use of session variable '$MY_VAR2' is not allowed in owners rights stored procedure
