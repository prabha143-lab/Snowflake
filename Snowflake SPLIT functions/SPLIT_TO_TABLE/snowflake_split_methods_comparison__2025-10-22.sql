CREATE OR REPLACE TABLE demo_split_text (
    id INT,
    full_name STRING,
    tags STRING
);

INSERT INTO demo_split_text (id, full_name, tags) VALUES
(1, 'John Doe', 'python,sql,snowflake'),
(2, 'Jane Smith', 'dbt,airflow,pyspark'),
(3, 'Alice Johnson', 'oracle,plsql,etl'),
(4, 'Bob Lee', NULL);



SELECT ID,FULL_NAME,
SPLIT(TAGS,',')[0] PART1,
SPLIT(TAGS,',')[1] PART2,
SPLIT(TAGS,',')[2] PART3
FROM demo_split_text;

ID	FULL_NAME	    PART1	     PART2	    PART3
1	John Doe	    "python"	"sql"	    "snowflake"
2	Jane Smith	    "dbt"	    "airflow"	"pyspark"
3	Alice Johnson	"oracle"	"plsql"	    "etl"
4	Bob Lee			 null        null        null


SELECT ID,FULL_NAME,
SPLIT_PART(TAGS,',',1) PART1,
SPLIT_PART(TAGS,',',2) PART2,
SPLIT_PART(TAGS,',',3) PART3
FROM demo_split_text;

ID	FULL_NAME	    PART1	 PART2	  PART3
1	John Doe	    python	 sql	  snowflake
2	Jane Smith	    dbt	     airflow  pyspark
3	Alice Johnson	oracle	 plsql	  etl
4	Bob Lee			null     null     null

SELECT 
    id,
    full_name,
    tag.index AS tag_position,         -- preserves original tag order
    tag.value::STRING AS tag_name      -- ensures clean string output
FROM demo_split_text,
     TABLE(SPLIT_TO_TABLE(tags, ',')) AS tag;

SELECT 
    id,
    full_name,
    tag.index AS tag_position,
    tag.value::STRING AS tag_name
FROM demo_split_text,
     LATERAL SPLIT_TO_TABLE(tags, ',') AS tag;

ID	FULL_NAME	     TAG_POSITION	TAG_NAME
1	John Doe	     1	            python
1	John Doe	     2	            sql
1	John Doe	     3	            snowflake
2	Jane Smith	     1	            dbt
2	Jane Smith	     2	            airflow
2	Jane Smith	     3	            pyspark
3	Alice Johnson	 1	            oracle
3	Alice Johnson	 2	            plsql
3	Alice Johnson	 3	            etl

