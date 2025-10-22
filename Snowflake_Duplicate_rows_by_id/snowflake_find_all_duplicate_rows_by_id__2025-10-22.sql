Return All Rows That Are Duplicates (Not Just the Keys)

CREATE OR REPLACE TABLE my_table (
  id INT,
  name STRING
);

INSERT INTO my_table VALUES
  (101, 'Arjun'),
  (102, 'Bhavana'),
  (103, 'Chaitanya'),
  (101, 'Arjun'),         -- duplicate
  (104, 'Deepa'),
  (105, 'Esha'),
  (102, 'Bhavana'),       -- duplicate
  (106, 'Farhan'),
  (107, 'Gauri'),
  (103, 'Chaitanya');     -- duplicate

WITH duplicates AS (
  SELECT id
  FROM my_table
  GROUP BY id
  HAVING COUNT(*) > 1
)
SELECT *
FROM my_table
JOIN duplicates USING (id);

ID	NAME
101	Arjun
102	Bhavana
103	Chaitanya
101	Arjun
102	Bhavana
103	Chaitanya

WITH window_count AS (
  SELECT *, COUNT(*) OVER (PARTITION BY id) AS id_count
  FROM my_table
)
SELECT * EXCLUDE (id_count)
FROM window_count
WHERE id_count > 1;

SELECT *
FROM my_table
QUALIFY COUNT(*) OVER (PARTITION BY id) > 1
ORDER BY id;

ID	NAME
101	Arjun
101	Arjun
102	Bhavana
102	Bhavana
103	Chaitanya
103	Chaitanya

SELECT *
FROM my_table t1
WHERE EXISTS (
  SELECT 1
  FROM my_table t2
  WHERE t1.id = t2.id
  GROUP BY t2.id
  HAVING COUNT(*) > 1
);

SELECT *
FROM my_table
QUALIFY COUNT(*) OVER (PARTITION BY id) > 1;

ID	NAME
101	Arjun
102	Bhavana
103	Chaitanya
101	Arjun
102	Bhavana
103	Chaitanya