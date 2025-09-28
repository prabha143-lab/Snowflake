-- Table A: List of countries (Team A)
CREATE OR REPLACE TABLE TableA (
    country STRING
);

-- Table B: List of countries (Team B)
CREATE OR REPLACE TABLE TableB (
    country STRING
);

-- Insert countries into TableA
INSERT INTO TableA (country) VALUES
('India'),
('Australia'),
('England'),
('South Africa');

-- Insert countries into TableB
INSERT INTO TableB (country) VALUES
('Pakistan'),
('New Zealand'),
('Sri Lanka'),
('West Indies'),
('India');

TableA contains: India, Australia, England, South Africa

TableB contains: Pakistan, West Indies, New Zealand, Sri Lanka

There is no overlap—no country appears in both tables. So when you run:

SELECT
    A.country AS team_1,
    B.country AS team_2
FROM
    TableA A
CROSS JOIN
    TableB B;

TEAM_1 TEAM_2
India Pakistan
India West Indies
India India
India New Zealand
India Sri Lanka
Australia Pakistan
Australia West Indies
Australia India
Australia New Zealand
Australia Sri Lanka
England Pakistan
England West Indies
England India
England New Zealand
England Sri Lanka
South Africa Pakistan
South Africa West Indies
South Africa India
South Africa New Zealand
South Africa Sri Lanka

SELECT
    A.country AS team_1,
    B.country AS team_2
FROM
    TableA A
CROSS JOIN
    TableB B
WHERE
    A.country != B.country;

TEAM_1 TEAM_2
India Pakistan
India West Indies
India New Zealand
India Sri Lanka
Australia Pakistan
Australia West Indies
Australia India
Australia New Zealand
Australia Sri Lanka
England Pakistan
England West Indies
England India
England New Zealand
England Sri Lanka
South Africa Pakistan
South Africa West Indies
South Africa India
South Africa New Zealand
South Africa Sri Lanka

   SELECT
    A.country AS team_1,
    B.country AS team_2
FROM
    TableA A
JOIN
    TableA B
ON
    A.country < B.country;

TEAM_1 TEAM_2
India South Africa
Australia India
Australia South Africa
Australia England
England India
England South Africa

You want to generate unique country matchups where each pair appears only once, and India vs Australia is included but Australia vs India is excluded. This means you are looking for non-repeating, non-reversed combinations across both tables.

SELECT
    A.country AS team_1,
    B.country AS team_2
FROM
    (
        SELECT country FROM TableA
        UNION
        SELECT country FROM TableB
    ) A
JOIN
    (
        SELECT country FROM TableA
        UNION
        SELECT country FROM TableB
    ) B
ON
    A.country < B.country;


TEAM_1 TEAM_2
New Zealand Sri Lanka
New Zealand South Africa
New Zealand West Indies
New Zealand Pakistan
Australia Sri Lanka
Australia England
Australia South Africa
Australia West Indies
Australia India
Australia Pakistan
Australia New Zealand
South Africa Sri Lanka
South Africa West Indies
Sri Lanka West Indies
England Sri Lanka
England South Africa
England West Indies
England India
England Pakistan
England New Zealand
Pakistan Sri Lanka
Pakistan South Africa
Pakistan West Indies
India Sri Lanka
India South Africa
India West Indies
India Pakistan
India New Zealand