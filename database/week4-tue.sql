-- Continuing with SQL
-- Somewhat arbitrary but illuatrative query
SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
    WHERE Site = 'nome'
    GROUP BY Species
    HAVING Nest_count > 10
    ORDER BY Species
    LIMIT 2;

-- We can nest queries!
SELECT Scientific_name, Nest_count FROM
    (SELECT Species, COUNT(*) AS Nest_count FROM Bird_nests
        WHERE Site = 'nome'
        GROUP BY Species
        HAVING Nest_count > 10
        ORDER BY Species
        LIMIT 2) JOIN Species
    ON Species = Code;

-- Outer joins
CREATE TEMP TABLE a (
    cola INTEGER,
    common INTEGER
);
INSERT INTO a VALUES (1, 1), (2, 2), (3, 3);
SELECT * FROM a;
CREATE TEMP TABLE b (
    common INTEGER,
    colb INTEGER,
);
INSERT INTO b VALUES (2, 2), (3,3), (4,4), (5,5);
SELECT * FROM b;

-- The joins weve been doing so far have been inner joins
SELECT * FROM a JOIN b USING (common);
SELECT * FROM a JOIN b ON a.common = b.common;

-- By doing an outer join, either left or right, we'll add certin missing rows
SELECT * FROM a LEFT JOIN b ON a.common = b.common;
SELECT * FROM a RIGHT JOIN b ON a.common = b.common;

-- A running example: What species do not have any nest data?
SELECT COUNT(*) FROM Species;
SELECT COUNT(DISTINCT Species) FROM Bird_nests;  -- only have 19 species with bird nest data

-- What are the 80 species that we don't have bird nest data for?
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT Species FROM Bird_nests); -- This gives the same answer as above, without DISTINCT, but is less efficient

-- method 2
SELECT Code, Species FROM Species LEFT JOIN Bird_nests
    ON Code = Species
    WHERE Species IS NULL;

-- also possible to join a table with itself, self-join

-- understanding a limitation of duckdb
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- lets add in observer
SELECT Nest_ID, Observer, COUNT (*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

-- duckdb solution #1
SELECT Nest_ID, Observer, COUNT (*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID, Observer;
-- duckdb solution 2
SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;
-- will need for hw i think

-- Views: a virtual table
CREATE VIEW my_nests AS 
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
        FROM Bird_nests JOIN Bird_eggs
        USING (Nest_ID)
        WHERE Nest_ID LIKE '13B%'
        GROUP BY Nest_ID;

.table

SELECT * FROM my_nests;
SELECT Nest_ID, Name, Num_eggs
    FROM my_nests JOIN Personnel
    ON Observer = Abbreviation;

--view
--temp table
-- whats the diff?
CREATE TEMP TABLE my_nests_temp_table AS
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
            FROM Bird_nests JOIN Bird_eggs
            USING (Nest_ID)
            WHERE Nest_ID LIKE '13B%'
            GROUP BY Nest_ID;

.table

-- what about modifications (inserts, updates, deletes) on a view? possible?
-- it depends
---- Whether its theoretically possible
---- How smart the database is

-- Last topic: set operations
-- UNION, UNION ALL, INTERSECT, EXCEPT
SELECT * FROM Bird_eggs LIMIT 5;

SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length*25.4 AS Length, Width*25.4 AS Width
    FROM Bird_eggs
    WHERE Book_page LIKE 'b14%'
UNION
SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length, Width
    FROM Bird_eggs
    WHERE Book_page NOT LIKE 'b14%';

-- method 3 for running example
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;

