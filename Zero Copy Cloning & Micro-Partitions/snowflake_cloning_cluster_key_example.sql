-- Create a table with a cluster key
CREATE OR REPLACE TABLE original_table (id INT, name VARCHAR)
CLUSTER BY (id);

-- Insert some data
INSERT INTO original_table (id, name) VALUES (1, 'John'), (2, 'Jane');

-- Clone the table
CREATE OR REPLACE TABLE cloned_table CLONE original_table;

-- Both tables point to the same micro-partitions

SELECT * FROM original_table;
-- Result: (1, 'John'), (2, 'Jane')

SELECT * FROM cloned_table;
-- Result: (1, 'John'), (2, 'Jane')

SELECT SYSTEM$CLUSTERING_INFORMATION('original_table');

SYSTEM$CLUSTERING_INFORMATION('ORIGINAL_TABLE')
{
  "cluster_by_keys" : "LINEAR(id)",
  "total_partition_count" : 1,
  "total_constant_partition_count" : 0,
  "average_overlaps" : 0.0,
  "average_depth" : 1.0,
  "partition_depth_histogram" : {
    "00000" : 0,
    "00001" : 1,
    "00002" : 0,
    "00003" : 0,
    "00004" : 0,
    "00005" : 0,
    "00006" : 0,
    "00007" : 0,
    "00008" : 0,
    "00009" : 0,
    "00010" : 0,
    "00011" : 0,
    "00012" : 0,
    "00013" : 0,
    "00014" : 0,
    "00015" : 0,
    "00016" : 0
  },
  "clustering_errors" : [ ]
}

SELECT SYSTEM$CLUSTERING_INFORMATION('cloned_table');

SYSTEM$CLUSTERING_INFORMATION('CLONED_TABLE')
{
  "cluster_by_keys" : "LINEAR(id)",
  "total_partition_count" : 1,
  "total_constant_partition_count" : 0,
  "average_overlaps" : 0.0,
  "average_depth" : 1.0,
  "partition_depth_histogram" : {
    "00000" : 0,
    "00001" : 1,
    "00002" : 0,
    "00003" : 0,
    "00004" : 0,
    "00005" : 0,
    "00006" : 0,
    "00007" : 0,
    "00008" : 0,
    "00009" : 0,
    "00010" : 0,
    "00011" : 0,
    "00012" : 0,
    "00013" : 0,
    "00014" : 0,
    "00015" : 0,
    "00016" : 0
  },
  "clustering_errors" : [ ]
}


Cluster Key on Cloned Table
When you clone a table with a cluster key, 
the cloned table will indeed have the same cluster key definition as the original table.

In your example, both the original_table and cloned_table 
show the same cluster key information when you run the SYSTEM$CLUSTERING_INFORMATION function. 
This indicates that the cloned table has inherited the cluster key definition from the original table.

Key Points:
Cloning a table with a cluster key will preserve the cluster key definition in the cloned table.
Both the original and cloned tables will have the same cluster key information, 
as shown by the SYSTEM$CLUSTERING_INFORMATION function.

This behavior ensures that the cloned table maintains the same clustering behavior 
as the original table, which can be beneficial for query performance and data management.