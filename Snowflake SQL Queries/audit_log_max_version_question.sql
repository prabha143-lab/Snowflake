Write a SQL query to return the row with the maximum version per ID, along with its corresponding Time.

CREATE OR REPLACE TABLE audit_log (
    ID INT,
    Version INT,
    Time TIME
);


INSERT INTO audit_log (ID, Version, Time) VALUES
(101, 1, '10:00:00'),
(101, 2, '11:15:00'),
(101, 3, '12:30:00'),
(102, 1, '09:45:00'),
(102, 5, '10:50:00'),
(103, 2, '08:00:00'),
(103, 4, '09:00:00');

SELECT * FROM audit_log;

ID	VERSION	TIME
101	1	10:00:00
101	2	11:15:00
101	3	12:30:00
102	1	09:45:00
102	5	10:50:00
103	2	08:00:00
103	4	09:00:00

SELECT ID, MAX(Version), Time
FROM audit_log
GROUP BY ID;

SQL compilation error: error line 28 at position 25 'AUDIT_LOG.TIME' in select clause is neither an aggregate nor in the group by clause.

SELECT a.*
FROM audit_log a
JOIN (
    SELECT ID, MAX(Version) AS MaxVersion
    FROM audit_log
    GROUP BY ID
) b ON a.ID = b.ID AND a.Version = b.MaxVersion;

ID	VERSION	TIME
101	3	12:30:00
102	5	10:50:00
103	4	09:00:00


SELECT *
FROM audit_log
QUALIFY ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Version DESC) = 1;

ID	VERSION	TIME
101	3	12:30:00
102	5	10:50:00
103	4	09:00:00

