-- Start with SQL
SELECT * FROM Site;
--SQL is case-insensitive, but uppercase is the tradition
select * from site;
-- Control C to abandon command in command line

-- A multi-line statement
SELECT *
FROM Site;
-- Need to highlight all lines that you want to run, or it will just try and run the last line

-- SELECT *: all rows, all columns

-- LIMIT clause
SELECT *
    FROM Site
    LIMIT 3;  -- Only return first 3 rows

-- can be combined with OFFSET clause
SELECT *
    FROM Site
    LIMIT 3
    OFFSET 3;  -- start 3 rows down (print rows 4 - 7)

-- selecting distinct items
SELECT * FROM Bird_nests LIMIT 1;
SELECT DISTINCT Species FROM Bird_nests;
SELECT DISTINCT Species, Observer, FROM Bird_nests;

-- add ordering
SELECT DISTINCT Species, Observer, 
    FROM Bird_nests
    ORDER BY Species;

-- look at Site table
SELECT * FROM Site;

-- Select distinct locations from site table, add limit clause to return 3 rows, and order them
SELECT DISTINCT Location FROM Site 
    ORDER BY Location
    LIMIT 3;

-- Filtering
SELECT * FROM Site WHERE Area < 200;
-- can be arbitraty expression
SELECT * FROM Site WHERE Area < 200 AND Latitude > 60;
-- not equal, classic operator is <>, but nowadays most databases support !=
SELECT * FROM Site WHERE Location <> 'Alaska, USA';
-- other operators:
-- LIKE for string matching, uses % as the wildcard character (not *)
SELECT * FROM Site WHERE Location LIKE '%Canada';
-- Is this case sensitive matching or not? Depends on the database
SELECT * FROM Site WHERE Location LIKE '%canada'; -- yes, duckdb is case sensitive
-- LIKE is primitive matching, but nowadays every supports regexp's
-- Common pattern: databases provide tons of functions
SELECT * FROM Site WHERE regexp_matches(Location, '.*west.*');

-- "select" expressions; i.e. you can do computation
SELECT Site_name, Area FROM Site;
SELECT Site_name, AREA*2.47 AS Area_acres FROM Site;

-- You can use your database as a calculator
SELECT 2+2;

-- String concatenation operator: classic one is ||, other via functions
SELECT Site_name || 'in' || Location FROM  Site;

-- AGGREGATION AND GROUPING
SELECT COUNT(*) FROM Species;
-- ^^ * means number of rows
SELECT COUNT (Scientific_name) FROM Species; -- count non null values in scientific name
-- can also count # of distinct values
SELECT DISTINCT Relevance FROM Species;
SELECT COUNT(DISTINCT Relevance) FROM Species;

-- moving on to arithemtic operations
SELECT AVG(Area) FROM Site;
SELECT AVG(Area) FROM Site WHERE Location LIKE '%Alaska%';
-- MIN, MAX;

-- What happends when you do this?
-- suppose we want the largest site and its name
SELECT Site_name, MAX(Area) FROM Site;

-- intro to grouping 
Select Location, MAX(Area)
    FROM Site 
    GROUP BY Location;

Select Location, COUNT(*), MAX(Area)
    FROM Site
    GROUP BY Location;

SELECT Location, COUNT(*), MAX(Area)
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location;

-- A WHERE clause limits the rows that are going in to the expression at the beginning
-- a HAVING clause filters the groups
SELECT Location, Count(*) AS Count, MAX(Area) AS Max_area  -- AS gives nicer names
    FROM Site
    WHERE Location LIKE '%Canada'
    GROUP BY Location
    HAVING Count > 1;

-- NULL processing
-- NULL indicates the absence of data in a table
-- But in an expression, it means unknown
SELECT COUNT(*) FROM Bird_nests;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge > 5;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge <= 5;
-- How can we find out which rows are null?
SELECT COUNT(*) FROM Bird_nests WHERE floatAge = NULL; -- no
-- The only way to find null values:
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NOT NULL;

-- Joins
SELECT * FROM Camp_assignment LIMIT 10;
SELECT * FROM Personnel;
SELECT * FROM Camp_assignment JOIN Personnel
    ON Observer = Abbreviation
    LIMIT 10;

-- You may need to qualify column names
SELECT * FROM Camp_assignment JOIN Personnel
    ON Camp_assignment.Observer = Personnel.Abbreviation
    LIMIT 10;

-- another way is to use aliases
SELECT * FROM Camp_assignment AS CA JOIN Personnel AS P
    ON CA.Observer = P.Abbreviation
    LIMIT 10;

-- relational algebra and nested queries and subqueries
SELECT COUNT(*) FROM Bird_nests; -- how many rows are in the bird nest table
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Bird_nests); -- count the num of rows in our table that counds rows in bird table
-- create temp table: when you close duckdb, table will vanish. remove temp to create permanent table
CREATE TEMP TABLE nest_count AS SELECT COUNT(*) FROM Bird_nests;
.table -- list out tables in database
SELECT * FROM nest_count;
DROP TABLE nest_count; -- get rid of table
-- another place to nest queries, in IN clauses
SELECT Observer FROM Bird_nests;
SELECT * FROM Personnel ORDER BY Abbreviation;
SELECT * FROM Bird_nests
    WHERE Observer IN (
        SELECT Abbreviation FROM Personnel
            WHERE Abbreviation LIKE 'a%'
    );