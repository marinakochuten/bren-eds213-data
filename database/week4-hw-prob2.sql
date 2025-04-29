-- Who worked with whom?
-- Step 1
SELECT * FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site;

-- Step 2
SELECT * FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site
    AND (A.Start <= B.End)
    AND (A.End >= B.Start); 

-- Step 3
SELECT * FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site
    AND (A.Start <= B.End)
    AND (A.End >= B.Start)
    WHERE A.Site = 'lkri'
    AND A.Observer < B.Observer; 

-- Step 4
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2 FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site
    AND (A.Start <= B.End)
    AND (A.End >= B.Start)
    WHERE A.Site = 'lkri'
    AND A.Observer < B.Observer;

-- BONUS!
SELECT A.Site, p1.Name AS Name_1, p2.Name AS Name_2 FROM Camp_assignment A 
    JOIN Camp_assignment B ON A.Site = B.Site
    JOIN Personnel p1 ON A.Observer = p1.Abbreviation
    JOIN Personnel p2 ON B.Observer = p2.Abbreviation
    AND (A.Start <= B.End)
    AND (A.End >= B.Start)
    WHERE A.Site = 'lkri'
    AND A.Observer < B.Observer;
