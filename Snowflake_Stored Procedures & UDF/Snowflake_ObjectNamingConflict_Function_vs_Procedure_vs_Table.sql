CREATE OR REPLACE PROCEDURE get_greeting(hour INT)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    greeting STRING;
BEGIN
    -- Use CASE for conditional logic and := for assignment
    greeting := CASE
        WHEN hour < 12 THEN 'Good Morning'
        WHEN hour < 18 THEN 'Good Afternoon'
        ELSE 'Good Evening'
    END;

    RETURN greeting;
END;
$$;

CALL get_greeting(21);

GET_GREETING
Good Evening


CREATE OR REPLACE FUNCTION get_greeting(hour INT)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    greeting STRING;
BEGIN
    -- Use CASE for conditional logic and := for assignment
    greeting := CASE
        WHEN hour < 12 THEN 'Good Morning'
        WHEN hour < 18 THEN 'Good Afternoon'
        ELSE 'Good Evening'
    END;

    RETURN greeting;
END;
$$;
--SQL compilation error: Object 'GET_GREETING' already exists as PROCEDURE


CREATE OR REPLACE TABLE GET_GREETING (id INT, name STRING);
--Table GET_GREETING successfully created.



Why the Table Was Allowed — But the Function Was Blocked
✅ Snowflake Allows:
A table named GET_GREETING

A procedure named GET_GREETING

A function named GET_GREETING

BUT…

❌ Snowflake Does Not Allow:
A function and a procedure with the same name and signature in the same schema

🧠 Key Rule: Object Type + Signature = Uniqueness
Snowflake enforces uniqueness within object types that share callable syntax, like:

Object Type	Callable Syntax	Signature Conflict?
Function	SELECT get_greeting(21)	✅ Yes
Procedure	CALL get_greeting(21)	✅ Yes
Table	SELECT * FROM get_greeting	❌ No conflict
So even though CREATE OR REPLACE is used, Snowflake won’t let you overwrite a procedure with a function — because they’re different object types, and the name/signature already exists in a callable context.

✅ Why Table Creation Works
Tables are not callable — they’re accessed via SELECT, not CALL or SELECT function(). So Snowflake allows:

sql
CREATE OR REPLACE TABLE get_greeting (id INT, name STRING);
Because it doesn’t conflict with the procedure or function namespace.

🧠 Interview Mnemonic
“Callable objects collide — tables don’t.”