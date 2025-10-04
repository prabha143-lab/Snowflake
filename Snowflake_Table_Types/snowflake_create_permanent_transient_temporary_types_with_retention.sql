Edition
Business Critical

CREATE OR REPLACE TABLE DEPT_PERM (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 91;  -- Optional: default is 1, max is 90

--SQL compilation error: Exceeds maximum allowable retention time (90 day(s)).

CREATE OR REPLACE TABLE DEPT_PERM (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 90;
--Table DEPT_PERM successfully created.


CREATE TRANSIENT TABLE DEPT_TRANSIENT (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 10;  -- Optional: can be 0 to disable Time Travel

--SQL compilation error: invalid value [10] for parameter 'DATA_RETENTION_TIME_IN_DAYS'

CREATE TRANSIENT TABLE DEPT_TRANSIENT (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 1;
--Table DEPT_TRANSIENT successfully created.


CREATE OR REPLACE TEMPORARY TABLE DEPT_TEMPORARY (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 91;
--SQL compilation error: Exceeds maximum allowable retention time (90 day(s)).

CREATE OR REPLACE TEMPORARY TABLE DEPT_TEMPORARY (
    DEPTNO INT,
    DNAME VARCHAR(50),
    LOC VARCHAR(50)
)
DATA_RETENTION_TIME_IN_DAYS = 90;
--Table DEPT_TEMPORARY successfully created.