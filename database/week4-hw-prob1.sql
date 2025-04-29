-- Which sites have no egg data?
-- Using a Code NOT IN (subquery) clause:
SELECT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site from Bird_eggs)
    ORDER BY Code;

-- Using an outer join with a WHERE clause
SELECT Code FROM Site LEFT JOIN Bird_eggs
    ON Code = Site
    WHERE Site IS NULL
    ORDER BY Code;

-- Using the set operation EXCEPT
SELECT Code FROM Site
EXCEPT
SELECT DISTINCT Site FROM Bird_eggs
ORDER BY Site;