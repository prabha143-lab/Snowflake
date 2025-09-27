In Snowflake, which SQL function combination can be used to reverse the order of values in a comma-separated string stored in a column?


CREATE OR REPLACE TEMP TABLE my_table (
    val STRING
);

INSERT INTO my_table (val)
VALUES ('1,2,3');


SELECT ARRAY_TO_STRING(
         ARRAY_AGG(num_val) 
         WITHIN GROUP (ORDER BY num_val DESC),
         ','
       ) AS reversed_val
FROM (
    SELECT CAST(TRIM(f.value) AS INT) AS num_val
    FROM my_table,
         LATERAL FLATTEN(INPUT => SPLIT(val, ',')) f
);

REVERSED_VAL
3,2,1


SELECT ARRAY_TO_STRING(
         ARRAY_REVERSE(SPLIT(val, ',')),
         ','
       ) AS reversed_val
FROM my_table;


REVERSED_VAL
3,2,1

SELECT REVERSE('(1,2,3)') AS reversed_str 

)3,2,1(

SELECT REVERSE('1,2,3') AS reversed_str;

REVERSED_STR
3,2,1

CREATE OR REPLACE TEMP TABLE my_table (
    val STRING
);

INSERT INTO my_table (val)
VALUES ('1,2,3');

SELECT REVERSE(val) AS reversed_str
FROM my_table;

REVERSED_STR
3,2,1
