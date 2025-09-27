
CREATE OR REPLACE TABLE EMPLOYEES (
    DEPT STRING,
    NAME STRING
);


INSERT INTO EMPLOYEES (DEPT, NAME) VALUES
    ('Sales', 'Alice'),
    ('Sales', 'Bob'),
    ('HR', 'Charlie'),
    ('HR', 'Diana'),
    ('Sales', 'Eve'),
    ('HR', 'Frank');

SELECT *FROM EMPLOYEES;

DEPT	NAME
Sales	Alice
Sales	Bob
HR	    Charlie
HR	    Diana
Sales	Eve
HR	    Frank

SELECT DEPT,
LISTAGG(NAME,',') WITHIN GROUP (ORDER BY NAME) ASALIAS
FROM EMPLOYEES
GROUP BY DEPT;

DEPT	ASALIAS

Sales	Alice,Bob,Eve
HR	    Charlie,Diana,Frank


SELECT DEPT,
LISTAGG(NAME,',') WITHIN GROUP (ORDER BY NAME DESC) ASALIAS
FROM EMPLOYEES
GROUP BY DEPT;

DEPT	ASALIAS

Sales	Eve,Bob,Alice
HR	    Frank,Diana,Charlie

SELECT 
  DEPT,
  ARRAY_TO_STRING(
    ARRAY_AGG(NAME) WITHIN GROUP (ORDER BY NAME),
    ','
  ) AS EMP_LIST
FROM EMPLOYEES
GROUP BY DEPT;

DEPT	EMP_LIST

Sales	Alice,Bob,Eve
HR	    Charlie,Diana,Frank
