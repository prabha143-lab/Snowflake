Query to Get Latest Version per Customer
*****************************************

-- Filename: Create_Customer_Version_Tracking_Table.sql

CREATE OR REPLACE TABLE customer_versions (
    customer_id INT,
    version INT,
    update_time TIMESTAMP,
    status STRING,
    source STRING
);

INSERT INTO customer_versions (customer_id, version, update_time, status, source) VALUES
(101, 1, '2023-08-01 09:15:00', 'Active',   'WebForm'),
(101, 2, '2023-08-02 10:45:00', 'Inactive', 'API'),
(102, 1, '2023-08-01 11:00:00', 'Active',   'WebForm'),
(102, 2, '2023-08-03 14:30:00', 'Active',   'MobileApp'),
(103, 1, '2023-08-04 08:20:00', 'Pending',  'API');



-- Filename: Get_Latest_Version_Per_Customer.sql

SELECT *
FROM customer_versions
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY version DESC
) = 1;



Output Snapshot (Expected)

customer_id	version	update_time	status	source
101	2	2023-08-02 10:45:00	Inactive	API
102	2	2023-08-03 14:30:00	Active	MobileApp
103	1	2023-08-04 08:20:00	Pending	API