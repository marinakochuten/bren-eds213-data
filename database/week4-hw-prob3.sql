-- Who's the culprit?
SELECT * FROM (
    SELECT Name, COUNT(*) AS Num_floated_nests FROM Bird_nests 
        JOIN Personnel ON Observer = Abbreviation
        WHERE Site = 'nome' 
        AND Year BETWEEN 1998 AND 2008
        AND ageMethod = 'float'
        GROUP BY Name
    ) WHERE Num_floated_nests = 36;

-- Dang it Emilie D'Astrous!!!