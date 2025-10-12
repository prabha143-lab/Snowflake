
-- Step 1: Create the input table
CREATE OR REPLACE TABLE input_names (name STRING);

-- Step 2: Insert the data
INSERT INTO input_names (name)
VALUES 
    ('RAJESH KUMAR REDDY'),
    ('RAJESH'),
    ('APARNA PAUL'),
    ('KOTLA-ROJA-REDDY');


SELECT *FROM input_names;

NAME
RAJESH KUMAR REDDY
RAJESH
APARNA PAUL
KOTLA-ROJA-REDDY

Expected output :


NAME	COL1	COL2	COL3
RAJESH KUMAR REDDY	RAJESH	KUMAR	REDDY
RAJESH	RAJESH		
APARNA PAUL	APARNA	PAUL	
KOTLA-ROJA-REDDY	KOTLA	ROJA	REDDY

SELECT
    SPLIT_PART(name, ' ', 1) AS COL1,
    SPLIT_PART(name, ' ', 2) AS COL2,
    SPLIT_PART(name, ' ', 3) AS COL3
FROM input_names;

COL1	COL2	COL3
RAJESH	KUMAR	REDDY
RAJESH		
APARNA	PAUL	
KOTLA-ROJA-REDDY		

SELECT
    name,
    REGEXP_SUBSTR(name, '\\S+', 1, 1) AS COL1,
    REGEXP_SUBSTR(name, '\\S+', 1, 2) AS COL2,
    REGEXP_SUBSTR(name, '\\S+', 1, 3) AS COL3
FROM input_names;

NAME	COL1	COL2	COL3
RAJESH KUMAR REDDY	RAJESH	KUMAR	REDDY
RAJESH	RAJESH		
APARNA PAUL	APARNA	PAUL	
KOTLA-ROJA-REDDY	KOTLA-ROJA-REDDY		

SELECT
    name,
    REGEXP_SUBSTR(REPLACE(name, '-', ' '), '\\S+', 1, 1) AS COL1,
    REGEXP_SUBSTR(REPLACE(name, '-', ' '), '\\S+', 1, 2) AS COL2,
    REGEXP_SUBSTR(REPLACE(name, '-', ' '), '\\S+', 1, 3) AS COL3
FROM input_names;


SELECT
    name,
    SPLIT(REPLACE(name, '-', ' '), ' ')[0] AS COL1,
    SPLIT(REPLACE(name, '-', ' '), ' ')[1] AS COL2,
    SPLIT(REPLACE(name, '-', ' '), ' ')[2] AS COL3
FROM input_names;

SELECT
    name,
    SPLIT_PART(REPLACE(name, '-', ' '), ' ', 1) AS COL1,
    SPLIT_PART(REPLACE(name, '-', ' '), ' ', 2) AS COL2,
    SPLIT_PART(REPLACE(name, '-', ' '), ' ', 3) AS COL3
FROM input_names;


NAME	COL1	COL2	COL3
RAJESH KUMAR REDDY	RAJESH	KUMAR	REDDY
RAJESH	RAJESH		
APARNA PAUL	APARNA	PAUL	
KOTLA-ROJA-REDDY	KOTLA	ROJA	REDDY


****************************************************************

CREATE OR REPLACE TABLE input_names (name STRING);

INSERT INTO input_names (name) VALUES('RAJESH KUMAR REDDY'),('RAJESH'),('APARNA PAUL'),('KOTLA-ROJA-REDDY');

SELECT 
    name,
    CASE WHEN ARRAY_SIZE(SPLIT(REPLACE(name, '-', ' '), ' ')) >= 1 THEN SPLIT_PART(REPLACE(name, '-', ' '), ' ', 1) ELSE NULL END AS COL1,
    CASE WHEN ARRAY_SIZE(SPLIT(REPLACE(name, '-', ' '), ' ')) >= 2 THEN SPLIT_PART(REPLACE(name, '-', ' '), ' ', 2) ELSE NULL END AS COL2,
    CASE WHEN ARRAY_SIZE(SPLIT(REPLACE(name, '-', ' '), ' ')) >= 3 THEN SPLIT_PART(REPLACE(name, '-', ' '), ' ', 3) ELSE NULL END AS COL3 
FROM input_names;


NAME	COL1	COL2	COL3
RAJESH KUMAR REDDY	RAJESH	KUMAR	REDDY
RAJESH	RAJESH		
APARNA PAUL	APARNA	PAUL	
KOTLA-ROJA-REDDY	KOTLA	ROJA	REDDY

******************************************************************



CREATE OR REPLACE TABLE input_names (name STRING);
-- Step 2: Insert the data
INSERT INTO input_names (name)
VALUES('RAJESH KUMAR REDDY'),('RAJESH'),('APARNA PAUL'),('KOTLA-ROJA-REDDY');

SELECT 
    name,
    OBJECT_CONSTRUCT('COL1', SPLIT_PART(REPLACE(name, '-', ' '), ' ', 1),
                     'COL2', SPLIT_PART(REPLACE(name, '-', ' '), ' ', 2),
                     'COL3', SPLIT_PART(REPLACE(name, '-', ' '), ' ', 3)) AS name_parts
FROM input_names;



NAME	NAME_PARTS
RAJESH KUMAR REDDY	{
  "COL1": "RAJESH",
  "COL2": "KUMAR",
  "COL3": "REDDY"
}
RAJESH	{
  "COL1": "RAJESH",
  "COL2": "",
  "COL3": ""
}
APARNA PAUL	{
  "COL1": "APARNA",
  "COL2": "PAUL",
  "COL3": ""
}
KOTLA-ROJA-REDDY	{
  "COL1": "KOTLA",
  "COL2": "ROJA",
  "COL3": "REDDY"
}



****************************************************************


CREATE OR REPLACE TABLE input_names (name STRING);
-- Step 2: Insert the data
INSERT INTO input_names (name)
VALUES('RAJESH KUMAR REDDY'),('RAJESH'),('APARNA PAUL'),('KOTLA-ROJA-REDDY');


SELECT 
    name,
    VALUE AS part,
    SEQ AS position
FROM input_names,
LATERAL FLATTEN(input => SPLIT(REPLACE(name, '-', ' '), ' '));

NAME	PART	POSITION
RAJESH KUMAR REDDY	"RAJESH"	1
RAJESH KUMAR REDDY	"KUMAR"	1
RAJESH KUMAR REDDY	"REDDY"	1
RAJESH	"RAJESH"	2
APARNA PAUL	"APARNA"	3
APARNA PAUL	"PAUL"	3
KOTLA-ROJA-REDDY	"KOTLA"	4
KOTLA-ROJA-REDDY	"ROJA"	4
KOTLA-ROJA-REDDY	"REDDY"	4


*********************************************************************


CREATE OR REPLACE TABLE split_input (id INT, raw_string STRING );

INSERT INTO split_input (id, raw_string) VALUES (1, 'a.b'), (2, 'c*d*e'), (3,'f-g-h')

SELECT 
    split_input.id, table1.value
FROM split_input,
TABLE(SPLIT_TO_TABLE(replace(raw_string,'*','.'), '.')) AS table1
ORDER BY table1.value;


ID	VALUE
1	a
1	b
2	c
2	d
2	e
3	f-g-h