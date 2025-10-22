create or replace table emp(   
  empno    number(4,0),   
  ename    varchar2(10),   
  job      varchar2(9),   
  mgr      number(4,0),   
  hiredate date,   
  sal      number(7,2),   
  comm     number(7,2),   
  deptno   number(2,0)  
)


insert into emp   
values(7839, 'KING', 'PRESIDENT', null, to_date('17-11-1981','dd-mm-yyyy'),5000, null, 10),
 (7698, 'BLAKE', 'MANAGER', 7839, to_date('1-5-1981','dd-mm-yyyy'), 2850, null, 30),
 (7782, 'CLARK', 'MANAGER', 7839, to_date('9-6-1981','dd-mm-yyyy'), 2450, null, 10),
 (7566, 'JONES', 'MANAGER', 7839, to_date('2-4-1981','dd-mm-yyyy'), 2975, null, 20),
 (7788, 'SCOTT', 'ANALYST', 7566, to_date('13-07-87','dd-mm-yyyy') ,3000, null, 20), 
 (7902, 'FORD', 'ANALYST', 7566,  to_date('3-12-1981','dd-mm-yyyy'),3000, null, 20),
 (7369, 'SMITH', 'CLERK', 7902,   to_date('17-12-1980','dd-mm-yyyy'),800, null, 20),
 (7499, 'ALLEN', 'SALESMAN', 7698, to_date('20-2-1981','dd-mm-yyyy'),1600, 300, 30),
 (7521, 'WARD', 'SALESMAN', 7698,  to_date('22-2-1981','dd-mm-yyyy'),1250, 500, 30),
 (7654, 'MARTIN', 'SALESMAN', 7698, to_date('28-9-1981','dd-mm-yyyy'),1250, 1400, 30),
 (7844, 'TURNER', 'SALESMAN', 7698, to_date('8-9-1981','dd-mm-yyyy'),1500, 0, 30),
 (7876, 'ADAMS', 'CLERK', 7788,  to_date('13-07-87', 'dd-mm-yyyy'),  1100, null, 20),
 (7900, 'JAMES', 'CLERK', 7698,  to_date('3-12-1981','dd-mm-yyyy'), 950, null, 30),
 (7934, 'MILLER', 'CLERK', 7782,  to_date('23-1-1982','dd-mm-yyyy'), 1300, null, 10);

SELECT *FROM EMP;


****************************************************************************************************
-- Query 1: Inline RANK() with QUALIFY
-- Filters top earners per department directly using QUALIFY
SELECT E.*,
       RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) AS rank
FROM emp E
QUALIFY rank = 1;

-- Output:
-- EMPNO | ENAME | JOB       | MGR  | HIREDATE   | SAL   | COMM | DEPTNO | RANK
-- ------|-------|-----------|------|------------|--------|------|--------|-----
-- 7839  | KING  | PRESIDENT |      | 1981-11-17 | 5000.00|      | 10     | 1
-- 7788  | SCOTT | ANALYST   | 7566 | 0087-07-13 | 3000.00|      | 20     | 1
-- 7902  | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00|      | 20     | 1
-- 7698  | BLAKE | MANAGER   | 7839 | 1981-05-01 | 2850.00|      | 30     | 1


***************************************************************************************************
-- Query 2: WITH clause + QUALIFY
-- Precomputes RANK() in CTE, then filters with QUALIFY
WITH ranked_employees AS (
    SELECT E.*,
           RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) AS rank
    FROM emp E
)
SELECT *
FROM ranked_employees
QUALIFY rank = 1;

-- Output: Same as Query 1


****************************************************************************************************
-- Query 3: WITH clause + WHERE
-- Precomputes RANK() in CTE, then filters with WHERE
WITH ranked_employees AS (
    SELECT E.*,
           RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) AS rank
    FROM emp E
)
SELECT *
FROM ranked_employees
WHERE rank = 1;

-- Output: Same as Query 1

****************************************************************************************************
-- Query 4: Pure inline QUALIFY without alias
-- Uses QUALIFY directly with RANK() — no CTE, no alias
SELECT *
FROM emp
QUALIFY RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) = 1;

-- Output (no RANK column):
-- EMPNO | ENAME | JOB       | MGR  | HIREDATE   | SAL   | COMM | DEPTNO
-- ------|-------|-----------|------|------------|--------|------|--------
-- 7839  | KING  | PRESIDENT |      | 1981-11-17 | 5000.00|      | 10
-- 7788  | SCOTT | ANALYST   | 7566 | 0087-07-13 | 3000.00|      | 20
-- 7902  | FORD  | ANALYST   | 7566 | 1981-12-03 | 3000.00|      | 20
-- 7698  | BLAKE | MANAGER   | 7839 | 1981-05-01 | 2850.00|      | 30
