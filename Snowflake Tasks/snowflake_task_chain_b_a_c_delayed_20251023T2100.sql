CREATE OR REPLACE TABLE my_table_b (
    id INT,
    name STRING,
    run_time TIMESTAMP
);

CREATE OR REPLACE TABLE my_table_a (
    id INT,
    name STRING,
    run_time TIMESTAMP
);

CREATE OR REPLACE TABLE my_table_c (
    id INT,
    name STRING,
    run_time TIMESTAMP
);

ALTER TASK IF EXISTS TASK_B SUSPEND;

DROP TASK IF EXISTS TASK_C;
DROP TASK IF EXISTS TASK_A;
DROP TASK IF EXISTS TASK_B;

ALTER WAREHOUSE my_wh RESUME;

-- ✅ Task B: Root task scheduled every 1 minute
CREATE OR REPLACE TASK TASK_B
WAREHOUSE = my_wh
SCHEDULE = 'USING CRON * * * * * UTC'
AS
INSERT INTO my_table_b (id, name, run_time)
VALUES (1, 'Task B ran', CURRENT_TIMESTAMP());

-- ✅ Task A: Runs after Task B, only if 30 seconds have passed
CREATE OR REPLACE TASK TASK_A
WAREHOUSE = my_wh
AFTER TASK_B
AS
INSERT INTO my_table_a (id, name, run_time)
SELECT 2, 'Task A ran after B', CURRENT_TIMESTAMP()
FROM (
    SELECT MAX(run_time) AS run_time FROM my_table_b
) AS last_b
WHERE TIMESTAMPDIFF(SECOND, last_b.run_time, CURRENT_TIMESTAMP()) >= 30;

-- ✅ Task C: Runs after Task A, only if 30 seconds have passed
CREATE OR REPLACE TASK TASK_C
WAREHOUSE = my_wh
AFTER TASK_A
AS
INSERT INTO my_table_c (id, name, run_time)
SELECT 3, 'Task C ran after A', CURRENT_TIMESTAMP()
FROM (
    SELECT MAX(run_time) AS run_time FROM my_table_a
) AS last_a
WHERE TIMESTAMPDIFF(SECOND, last_a.run_time, CURRENT_TIMESTAMP()) >= 30;

ALTER TASK TASK_B RESUME;


SELECT * FROM my_table_b;
SELECT * FROM my_table_a;
SELECT * FROM my_table_c;
