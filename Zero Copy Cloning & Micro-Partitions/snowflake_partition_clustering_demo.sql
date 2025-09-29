CREATE OR REPLACE TABLE demo_partitioned (
  id INT,
  name STRING,
  age INT,
  country STRING
);


-- Run this block 10 times to simulate 10 inserts
INSERT INTO demo_partitioned
SELECT
  SEQ4() AS id,
  RANDSTR(10, RANDOM()) AS name,
  UNIFORM(1, 100, RANDOM()) AS age,
  RANDSTR(5, RANDOM()) AS country
FROM TABLE(GENERATOR(ROWCOUNT => 100000));


CREATE OR REPLACE PROCEDURE insert_batches()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
for (let i = 0; i < 10; i++) {
  snowflake.execute({
    sqlText: `
      INSERT INTO demo_partitioned
      SELECT
        SEQ4() AS id,
        RANDSTR(10, RANDOM()) AS name,
        UNIFORM(1, 100, RANDOM()) AS age,
        RANDSTR(5, RANDOM()) AS country
      FROM TABLE(GENERATOR(ROWCOUNT => 100000))
    `
  });
}
return 'Inserted 1 million rows in 10 batches';
$$;


CALL insert_batches();

SELECT * FROM demo_partitioned WHERE age = 25;


ALTER TABLE demo_partitioned CLUSTER BY (age);


SELECT * FROM demo_partitioned WHERE age = 25;


ALTER TABLE demo_partitioned RECLUSTER;

000002 (0A000): Unsupported feature 'RECLUSTER'.
