CREATE OR REPLACE TABLE employee (
  id INT,
  name STRING,
  salary NUMBER
);

INSERT INTO employee VALUES (1, 'Alice', 50000);

CREATE OR REPLACE STREAM employee_stream ON TABLE employee;

SELECT * FROM employee_stream;


BEGIN;
UPDATE employee SET salary = 55000 WHERE id = 1;
DELETE FROM employee WHERE id = 1;
COMMIT;

SELECT * FROM employee_stream;

ID	NAME	SALARY	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
1	Alice	50000	DELETE	FALSE	03d3e6cbf04e5ccbf47756a58f2c81810efbeaeb

Key Insight:
Even though you updated the row before deleting it, Snowflake only tracks the final state of the row within the transaction. 
Since the row was ultimately deleted, the stream emits a DELETE action. But here's the twist:

METADATA$ISUPDATE = FALSE → means the row was not updated before deletion according to Snowflake’s internal change tracking.