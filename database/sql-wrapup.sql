-- Exploring why grouping by Scientific name is not quiet correct
SELECT * FROM Species LIMIT 3;

--are there duplicate scientific names?
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Scientific_name) FROM Species;

SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurrences > 1;

    --- git restore database if you manipulated your database and want to go back

CREATE TEMP TABLE t AS (
    SELECT Scientific_name, COUNT(*) AS Num_name_occurrences
    FROM Species
    GROUP BY Scientific_name
    HAVING Num_name_occurrences > 1
);

SELECT * FROM t;

-- Explanation for repeated scinetific names or null repeated sci name
SELECT * FROM Species s JOIN t
    ON s.Scientific_name = t.Scientific_name
    OR (s.Scientific_name IS NULL AND t.Scientific_name IS NULL);

-- inserting data
INSERT INTO Species VALUES ('abcd', 'thing', 'scientific_name', NULL);
SELECT * FROM Species;
-- you can explicitly label columns
INSERT INTO Species 
    (Common_name, Scientific_name, Code, Relevance)
    VALUES
    ('thing 2', 'another scientific name', 'efgh', NULL);
SELECT * FROM Species;

-- take advantage of default values
INSERT INTO Species
    (Common_name, Code)
    VALUES('thing 3', 'ijkyl');
SELECT * FROM Species;

-- Updates and Delets will demolish the entire table unless limited by where

-- strategies to save yourself
-- doing a select first
SELECT * FROM Bird_eggs WHERE Nest_ID LIKE 'z%';

SELECT * FROM Bird_nests;

SELECT * FROM Bird_nests WHERE Site = 'chur';

-- try to create a copy of the table
CREATE TABLE nest_temp AS (SELECT * FROM Bird_nests);
DELETE FROM nest_temp WHERE Site = 'chur';

-- other ideas
xDELETE FROM ... WHERE ...; 




