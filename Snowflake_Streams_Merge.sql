CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers;

CREATE OR REPLACE TABLE target_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

SELECT *FROM target_customers;

SELECT * FROM source_customers_stream;

-- Update a record
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-12 04:03:46.106	INSERT	TRUE	d63790f60e2602b24663e627ceae5965c01b43ea
101	Alice	alice@example.com	2025-09-12 04:03:35.885	DELETE	TRUE	d63790f60e2602b24663e627ceae5965c01b43ea

SELECT * FROM source_customers;

-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-12 04:03:46.106	INSERT	TRUE	d63790f60e2602b24663e627ceae5965c01b43ea
104	David	david@example.com	2025-09-12 04:04:07.092	INSERT	FALSE	41c58b8db08d571998d5b787b1e71c8f8ff9e532
101	Alice	alice@example.com	2025-09-12 04:03:35.885	DELETE	TRUE	d63790f60e2602b24663e627ceae5965c01b43ea

INSERT INTO target_customers (customer_id, name, email, last_updated)
VALUES (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP);


 SELECT * FROM source_customers_stream
  WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE)

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-12 04:03:46.106	INSERT	TRUE	d63790f60e2602b24663e627ceae5965c01b43ea
104	David	david@example.com	2025-09-12 04:04:07.092	INSERT	FALSE	41c58b8db08d571998d5b787b1e71c8f8ff9e532

  
MERGE INTO target_customers AS tgt
USING (
  SELECT * FROM source_customers_stream
  WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE)
) AS src
ON tgt.customer_id = src.customer_id

WHEN MATCHED THEN
  UPDATE SET
    tgt.name = src.name,
    tgt.email = src.email,
    tgt.last_updated = src.last_updated

WHEN NOT MATCHED THEN
  INSERT (customer_id, name, email, last_updated)
  VALUES (src.customer_id, src.name, src.email, src.last_updated);

  number of rows inserted	number of rows updated
1	1

SELECT * FROM source_customers_stream;

SELECT *FROM target_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-12 04:03:46.106
104	David	david@example.com	2025-09-12 04:04:07.092


-----------------------------------------------------------------------

CREATE OR REPLACE TABLE source_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES
  (101, 'Alice', 'alice@example.com', CURRENT_TIMESTAMP),
  (102, 'Bob', 'bob@example.com', CURRENT_TIMESTAMP),
  (103, 'Charlie', 'charlie@example.com', CURRENT_TIMESTAMP);

CREATE OR REPLACE STREAM source_customers_stream ON TABLE source_customers;

CREATE OR REPLACE TABLE target_customers (
  customer_id INT,
  name STRING,
  email STRING,
  last_updated TIMESTAMP
);

SELECT *FROM target_customers;

SELECT * FROM source_customers_stream;

-- Update a record
UPDATE source_customers
SET email = 'alice.new@example.com', last_updated = CURRENT_TIMESTAMP
WHERE customer_id = 101;

SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-12 00:31:50.053	INSERT	TRUE	a65d9846856f82bbc701d70198c411fb48ef127b
101	Alice	alice@example.com	2025-09-12 00:31:33.407	DELETE	TRUE	a65d9846856f82bbc701d70198c411fb48ef127b	5246d4c6497d70818d0bbda2e15ea9f02d80665e

SELECT * FROM source_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-12 00:31:50.053
102	Bob	bob@example.com	2025-09-12 00:31:33.407
103	Charlie	charlie@example.com	2025-09-12 00:31:33.407

-- Insert a new record
INSERT INTO source_customers (customer_id, name, email, last_updated)
VALUES (104, 'David', 'david@example.com', CURRENT_TIMESTAMP);

SELECT * FROM source_customers_stream;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED	METADATA$ACTION	METADATA$ISUPDATE	METADATA$ROW_ID
101	Alice	alice.new@example.com	2025-09-12 00:31:50.053	INSERT	TRUE	a65d9846856f82bbc701d70198c411fb48ef127b
104	David	david@example.com	2025-09-12 00:32:20.702	INSERT	FALSE	2cc67ee4a640d93c6db32e12c9189816a260a462
101	Alice	alice@example.com	2025-09-12 00:31:33.407	DELETE	TRUE	a65d9846856f82bbc701d70198c411fb48ef127b

 SELECT * FROM source_customers_stream
  WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE)

  
MERGE INTO target_customers AS tgt
USING (
  SELECT * FROM source_customers_stream
  WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE = TRUE)
) AS src
ON tgt.customer_id = src.customer_id

WHEN MATCHED THEN
  UPDATE SET
    tgt.name = src.name,
    tgt.email = src.email,
    tgt.last_updated = src.last_updated

WHEN NOT MATCHED THEN
  INSERT (customer_id, name, email, last_updated)
  VALUES (src.customer_id, src.name, src.email, src.last_updated);

  number of rows inserted	number of rows updated
2	0

SELECT * FROM source_customers_stream;

SELECT *FROM target_customers;

CUSTOMER_ID	NAME	EMAIL	LAST_UPDATED
101	Alice	alice.new@example.com	2025-09-12 04:06:10.847
104	David	david@example.com	2025-09-12 04:06:18.751