-- Add snow cover data to database
CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 and 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 and 130) ,
    Land_cover REAL CHECK (Land_cover BETWEEN 0 and 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 and 130),
    Observer VARCHAR, 
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)

);

-- Add all of the data to our new table - Important to specify that NA should be imported as NULL
COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");

-- Look at it!
SELECT * FROM Snow_cover LIMIT 10;

-- EXERCISES!
-- Q1: What is the average snow cover at each site
SELECT Site, AVG(Snow_cover) AS avg_snow_cover FROM Snow_cover 
    GROUP BY Site ORDER BY avg_snow_cover DESC;

-- Q2: Top 3 most snowy sites
SELECT Site, AVG(Snow_cover) AS avg_snow_cover FROM Snow_cover 
    GROUP BY Site ORDER BY avg_snow_cover DESC
    LIMIT 3;

-- Q3: save this as a VIEW
CREATE VIEW Site_avg_snowcover AS(
    SELECT Site, AVG(Snow_cover) AS avg_snow_cover FROM Snow_cover 
    GROUP BY Site 
    ORDER BY avg_snow_cover DESC
    LIMIT 5
);

SELECT * FROM Site_avg_snowcover;

CREATE TEMP TABLE Site_avg_snowcover_table AS(
    SELECT Site, AVG(Snow_cover) AS avg_snow_cover FROM Snow_cover 
    GROUP BY Site 
    ORDER BY avg_snow_cover DESC
    LIMIT 5
);

SELECT * FROM Site_avg_snowcover_table;

-- DANGER ZONE AKA updating data
-- We found that 0s at Plot = `brw0` with snow_cover == 0 are actually no data (NULL)

-- Before updating the real table, update on a TEMP table to verify that it will work
CREATE TEMP TABLE Snow_cover_backup AS (SELECT * FROM Snow_cover);
.tables

-- Update the snow cover column
UPDATE Snow_cover_backup SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;
-- check
SELECT * FROM Snow_cover_backup WHERE Plot = 'brw0'; 
-- Now that we verified it worked, we can update the real version
SELECT * FROM Site_avg_snowcover; -- check the average in the view
SELECT * FROM Site_avg_snowcover_table; -- check the average in the temp table
-- will this update change the averages in the view table or the temp table??
UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0; -- run the update
SELECT * FROM Site_avg_snowcover; -- check the average in the view
SELECT * FROM Site_avg_snowcover_table; -- check the average in the temp table