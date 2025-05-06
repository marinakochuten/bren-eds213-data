SELECT Nest_ID, AVG(3.14/6*Width*Width*Length) AS Avg_volume
    FROM Bird_eggs
    WHERE Nest_ID LIKE '14%'   -- very first thing that happens
    GROUP BY Nest_ID
    HAVING Avg_volume >10000
    ORDER BY Avg_volume DESC
    LIMIT 3 OFFSET 17;

-- Can group by a whole expression
SELECT substring(Nest_ID, 1, 3), AVG(3.14/6*Width*Width*Length) AS Avg_volume
    FROM Bird_eggs
    WHERE Nest_ID LIKE '14%'   -- very first thing that happens
    GROUP BY substring(Nest_ID, 1, 3)
    HAVING Avg_volume >10000
    ORDER BY Avg_volume DESC;

-- Joins: create a new mega-table

