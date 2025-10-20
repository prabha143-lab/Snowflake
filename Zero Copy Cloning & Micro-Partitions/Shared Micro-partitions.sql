
-- Create a table
CREATE TABLE original_table (id INT, name VARCHAR);

-- Insert some data
INSERT INTO original_table (id, name) VALUES (1, 'John'), (2, 'Jane');

-- Clone the table
CREATE TABLE cloned_table CLONE original_table;

-- Both tables point to the same micro-partitions

SELECT * FROM original_table;

SELECT * FROM cloned_table;

ID	NAME
1	John
2	Jane

SELECT *
FROM information_schema.table_storage_metrics
WHERE table_name IN ('ORIGINAL_TABLE', 'CLONED_TABLE');

TABLE_CATALOG	TABLE_SCHEMA	TABLE_NAME	ID	CLONE_GROUP_ID	IS_TRANSIENT	ACTIVE_BYTES	TIME_TRAVEL_BYTES	FAILSAFE_BYTES	RETAINED_FOR_CLONE_BYTES	TABLE_CREATED	TABLE_DROPPED	TABLE_ENTERED_FAILSAFE	CATALOG_CREATED	CATALOG_DROPPED	SCHEMA_CREATED	SCHEMA_DROPPED	COMMENT
MYSNOW	PUBLIC	ORIGINAL_TABLE	86018	86018	NO	0	0	0	0	2025-10-20 04:00:57.787 -0700			2025-09-25 19:49:00.316 -0700		2025-09-25 19:49:00.338 -0700		
MYSNOW	PUBLIC	CLONED_TABLE	87042	86018	NO	0	0	0	0	2025-10-20 04:01:08.201 -0700			2025-09-25 19:49:00.316 -0700		2025-09-25 19:49:00.338 -0700		


SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
WHERE TABLE_NAME IN('ORIGINAL_TABLE', 'CLONED_TABLE');

TABLE_CATALOG	TABLE_SCHEMA	TABLE_NAME	ID	CLONE_GROUP_ID	IS_TRANSIENT	ACTIVE_BYTES	TIME_TRAVEL_BYTES	FAILSAFE_BYTES	RETAINED_FOR_CLONE_BYTES	TABLE_CREATED	TABLE_DROPPED	TABLE_ENTERED_FAILSAFE	CATALOG_CREATED	CATALOG_DROPPED	SCHEMA_CREATED	SCHEMA_DROPPED	COMMENT
MYSNOW	PUBLIC	ORIGINAL_TABLE	86018	86018	NO	0	0	0	0	2025-10-20 04:00:57.787 -0700			2025-09-25 19:49:00.316 -0700		2025-09-25 19:49:00.338 -0700		
MYSNOW	PUBLIC	CLONED_TABLE	87042	86018	NO	0	0	0	0	2025-10-20 04:01:08.201 -0700			2025-09-25 19:49:00.316 -0700		2025-09-25 19:49:00.338 -0700		



Inserting into Cloned Table
When you insert new records into the cloned table, it creates new micro-partitions for the cloned table. The original table remains unchanged.
SQL
-- Insert a new row into the cloned table
INSERT INTO cloned_table (id, name) VALUES (3, 'Bob');

-- Cloned table has the new row
SELECT * FROM cloned_table;  
-- Result: (1, 'John'), (2, 'Jane'), (3, 'Bob')

-- Original table remains the same
SELECT * FROM original_table;  
-- Result: (1, 'John'), (2, 'Jane')
Inserting into Original Table
When you insert new records into the original table, the cloned table remains unchanged.
SQL
-- Insert a new row into the original table
INSERT INTO original_table (id, name) VALUES (4, 'Alice');

-- Cloned table remains the same
SELECT * FROM cloned_table;  
-- Result: (1, 'John'), (2, 'Jane'), (3, 'Bob')

-- Original table has the new row
SELECT * FROM original_table;  
-- Result: (1, 'John'), (2, 'Jane'), (4, 'Alice')

Key Takeaways:
Inserting new records into the cloned table does not impact the original table.
Inserting new records into the original table does not impact the cloned table.
Both tables maintain their independence after cloning.



Shared Micro-partitions: When you clone a table (emp), do the original 
and the cloned table share the same micro-partitions?

When you clone a table, the original and the clone both point to the same micro-partitions. 
This is Zero-Copy Cloning, which is instant and uses no extra storage initially. 
The clone is a separate logical table, but it shares the physical data with the original.



DML on Cloned Table: If you perform DML operations (INSERT, UPDATE, DELETE) 
on the cloned table, will new micro-partitions be created for all three operations?

Any DML operation (INSERT, UPDATE, or DELETE) on the cloned table triggers Snowflake's "copy-on-write" mechanism. 
Because micro-partitions are immutable, Snowflake creates new micro-partitions to store the changes. 
The cloned table's metadata then updates to point to these new partitions, 
while the original tables pointers remain unchanged.

DML on Original Table: If you then perform DML operations on the original table, 
will the changes be reflected in the cloned table?

Changes to the original table are not reflected in the cloned table. 
The clone is a static snapshot of the original at the moment it was created. 
It remains completely independent and isolated from any new data or modifications made to the original table.


Here is a concise, short summary of the concepts you provided.

Shared Micro-partitions
When you clone a table, the original and the clone both point to the same micro-partitions. 
This is Zero-Copy Cloning, which is instant and uses no extra storage initially. 
The clone is a separate logical table, but it shares the physical data with the original.

DML on Cloned Table
Any DML operation (INSERT, UPDATE, or DELETE) on the cloned table triggers Snowflake's "copy-on-write" mechanism. 
Because micro-partitions are immutable, Snowflake creates new micro-partitions to store the changes. 
The cloned table's metadata then updates to point to these new partitions, while the original tables pointers remain unchanged.

DML on Original Table
Changes to the original table are not reflected in the cloned table. 
The clone is a static snapshot of the original at the moment it was created. 
It remains completely independent and isolated from any new data or modifications made to the original table.