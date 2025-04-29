-- Compute average volume per bird nest
CREATE TEMP TABLE Averages AS
    SELECT Nest_ID, AVG((3.14/6) * Width * Width * Length) AS Avg_volume
    FROM Bird_eggs
    GROUP BY Nest_ID;

-- Join averages table with Bird_nests to get species code and compute max avg volume per species
CREATE TEMP TABLE Species_max_avg AS
    SELECT Species, MAX(Avg_volume) AS max_avg_vol FROM Bird_nests 
        JOIN Averages USING (Nest_ID)
        GROUP BY Species;

-- Join with Species to get scientific names
SELECT Scientific_name, max_avg_vol FROM Species_max_avg
    JOIN Species ON Species = Code
    ORDER BY max_avg_vol DESC;