-- Create Table A
CREATE OR REPLACE TABLE A (
    id INT
);

-- Insert records into Table A
INSERT INTO A (id) VALUES
(1), (2), (3);

-- Create Table B
CREATE OR REPLACE TABLE B (
    id INT
);

-- Insert records into Table B
INSERT INTO B (id) VALUES
(1), (2), (3), (4), (5), (6);

SELECT A.ID,B.ID
FROM A,B
WHERE A.ID=B.ID;

SELECT *FROM B
MINUS
SELECT *FROM A;

SELECT *FROM B
WHERE NOT EXISTS(SELECT 1 FROM A WHERE A.ID=B.ID)
ORDER BY ID;

ID
5
6
4

SELECT B.ID FROM B
LEFT JOIN A
ON B.ID=A.ID
AND A.ID IS NULL;

ID
1
2
3
4
5
6

This query misplaces the filter condition A.ID IS NULL inside the ON clause.

The ON clause is used to define how rows are matched between tables — not to filter unmatched rows.

Because A.ID IS NULL is part of the join condition, it prevents any matches from happening, so the join behaves like a CROSS JOIN, returning all rows from B with NULLs from A.

❌ Returns: 1, 2, 3, 4, 5, 6 — which is incorrect for your goal.

SELECT B.id
FROM B
LEFT JOIN A ON B.id = A.id
WHERE A.id IS NULL;

ID
4
5
6