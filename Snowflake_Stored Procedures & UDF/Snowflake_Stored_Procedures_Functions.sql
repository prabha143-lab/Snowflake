CREATE OR REPLACE PROCEDURE ADD_TWO_NUMBERS(A NUMBER ,B NUMBER)
RETURNS INT
LANGUAGE SQL
AS
$$
BEGIN
RETURN A+B;
END
$$
.

CALL ADD_TWO_NUMBERS(2,4);

Output:

ADD_TWO_NUMBERS
6


************************************

CREATE OR REPLACE FUNCTION add_numbers_sql(a INT, b INT)
RETURNS INT
LANGUAGE SQL
AS
$$
  a + b
$$;


SELECT add_numbers_sql(5, 3);

ADD_NUMBERS_SQL(5, 3)
8



***************************************

CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS VARCHAR   -- Any return data type is required syntactically, even if procedure does not return meaningful value
LANGUAGE SQL
AS
$$
BEGIN
  -- Do some operation, but no RETURN statement
  LET result NUMBER := A + B;
  -- You can do other tasks here without returning a value
END;
$$;


CALL add_two_numbers_no_return(2, 4);

ADD_TWO_NUMBERS_NO_RETURN
null


**********************

CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS VARCHAR   -- Any return data type is required syntactically, even if procedure does not return meaningful value
LANGUAGE SQL
AS
$$
BEGIN
null;
END;
$$;
--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(2, 4);

ADD_TWO_NUMBERS_NO_RETURN
null


CREATE OR REPLACE PROCEDURE add_two_numbers(a NUMBER, b NUMBER) 
RETURNS VARCHAR 
LANGUAGE SQL AS 
$$ 
BEGIN 
RETURN 'Sum is: ' || (a + b); 
END; 
$$;--Function ADD_TWO_NUMBERS successfully created.



*****************************************

CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  NULL;
END;
$$;--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(12,13)

ADD_TWO_NUMBERS_NO_RETURN
null


CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
BEGIN
  NULL;
END;
$$;--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(12,13)

ADD_TWO_NUMBERS_NO_RETURN
null


*******************************************


CREATE OR REPLACE PROCEDURE compare_numbers(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;


Selection deleted
END; 
$$;--Function ADD_TWO_NUMBERS successfully created.



*****************************************

CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  NULL;
END;
$$;--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(12,13)

ADD_TWO_NUMBERS_NO_RETURN
null


CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
BEGIN
  NULL;
END;
$$;--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(12,13)

ADD_TWO_NUMBERS_NO_RETURN
null


*******************************************


CREATE OR REPLACE PROCEDURE compare_numbers(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;

SQL compilation error: syntax error line 128 at position 5 unexpected 'a'. syntax error line 3 at position 11 unexpected 'THEN'. syntax error line 5 at position 8 unexpected 'a'. syntax error line 5 at position 14 unexpected 'THEN'.


CREATE OR REPLACE FUNCTION compare_numbers(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;


Selection deleted
CREATE OR REPLACE PROCEDURE add_two_numbers_no_return(A NUMBER, B NUMBER)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
BEGIN
  NULL;
END;
$$;--Function ADD_TWO_NUMBERS_NO_RETURN successfully created.

CALL add_two_numbers_no_return(12,13)

ADD_TWO_NUMBERS_NO_RETURN
null


*******************************************


CREATE OR REPLACE PROCEDURE compare_numbers(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;

SQL compilation error: syntax error line 128 at position 5 unexpected 'a'. syntax error line 3 at position 11 unexpected 'THEN'. syntax error line 5 at position 8 unexpected 'a'. syntax error line 5 at position 14 unexpected 'THEN'.


CREATE OR REPLACE FUNCTION compare_numbers(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;

Compilation of SQL UDF failed: SQL compilation error: syntax error line 3 at position 2 unexpected 'IF'. syntax error line 3 at position 11 unexpected 'THEN'.



CREATE OR REPLACE PROCEDURE compare_numbers_proc(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;

SQL compilation error: syntax error line 283 at position 5 unexpected 'a'. syntax error line 3 at position 11 unexpected 'THEN'. syntax error line 5 at position 8 unexpected 'a'. syntax error line 5 at position 14 unexpected 'THEN'.




CREATE OR REPLACE PROCEDURE compare_numbers_proc(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
  RETURN CASE
    WHEN a > b THEN 'A is greater'
    WHEN a < b THEN 'B is greater'
    ELSE 'Both are equal'
  END;
END;
$$;--Function COMPARE_NUMBERS_PROC successfully created.


CREATE OR REPLACE PROCEDURE compare_numbers_proc(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
BEGIN
  IF a > b THEN
    RETURN 'A is greater';
  ELSIF a < b THEN
    RETURN 'B is greater';
  ELSE
    RETURN 'Both are equal';
  END IF;
END;
$$;

Language JAVASCRIPT does not support type 'NUMBER(38,0)' for argument or return type.



CREATE OR REPLACE PROCEDURE compare_numbers_proc(a FLOAT, b FLOAT)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
  if (a > b) {
    return 'A is greater';
  } else if (a < b) {
    return 'B is greater';
  } else {
    return 'Both are equal';
  }
$$;--Function COMPARE_NUMBERS_PROC successfully created.



CREATE OR REPLACE PROCEDURE compare_numbers_proc(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
  result VARCHAR;
BEGIN
  IF a > b THEN
    result := 'A is greater';
  ELSIF a < b THEN
    result := 'B is greater';
  ELSE
    result := 'Both are equal';
  END IF;

  RETURN result;
END;
$$;

SQL compilation error: syntax error line 357 at position 5 unexpected 'a'. syntax error line 5 at position 11 unexpected 'THEN'. syntax error line 7 at position 8 unexpected 'a'. syntax error line 7 at position 14 unexpected 'THEN'.


CREATE OR REPLACE PROCEDURE compare_numbers_proc(a NUMBER, b NUMBER)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
SELECT CASE
  WHEN a > b THEN 'A is greater'
  WHEN a < b THEN 'B is greater'
  ELSE 'Both are equal'
END;
$$;


Function COMPARE_NUMBERS_PROC successfully created.
