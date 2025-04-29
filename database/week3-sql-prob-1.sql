-- PART 1
-- Create temp table to test AVG function
CREATE TEMP TABLE avg_func_test(
    value REAL
);

-- Add some data to table
INSERT INTO avg_func_test (value) VALUES
(2),
(5),
(5),
(2),
(NULL);

-- If AVG ignores NULL values, we will expect this to return 3.5. If it does not ignore, it should return 2.8
SELECT AVG(value) FROM avg_func_test;

-- It returned 3.5, AVG does ignore NULL values!


-- PART 2 - which is correct?
SELECT SUM(value)/COUNT(*) FROM avg_func_test;
-- This is not correct and is returning 2.8. 
-- That is because COUNT(*) counts all rows, including those that contain NULL in my column of interest

SELECT SUM(value)/COUNT(value) FROM avg_func_test;
-- This way is correct!! 
-- COUNT(mycolumn) counts only the rows where my column is not NULL. 

DROP TABLE avg_func_test;