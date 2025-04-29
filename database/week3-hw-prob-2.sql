-- PART 1
-- We want to know what site has the largest area, but this code is flawed:
SELECT Site_name, MAX(Area) FROM Site;
-- MAX is an aggregate function, collasping the Area column down into one row - the max of the column.
-- It is not considering Site_name as a part of this aggregating, so it does not know which row to return alongside max area

-- PART 2
SELECT Site_name, Area FROM Site
    ORDER BY Area DESC
    LIMIT 1;

-- PART 3
SELECT Site_name, Area FROM Site WHERE Area = (SELECT MAX(Area) FROM Site);