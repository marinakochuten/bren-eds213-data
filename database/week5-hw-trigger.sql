.mode table

-- PART 1
-- Create trigger
CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN
        UPDATE Bird_eggs
        SET Egg_num = (
            SELECT IFNULL (MAX(Egg_num), 0) + 1  -- If egg_num is null, treat and 0. Then add 1 to get next egg number
            FROM Bird_eggs
            WHERE Nest_ID = new.Nest_ID AND Egg_num IS NOT NULL)
        WHERE Nest_ID = new.Nest_ID AND Egg_num IS NULL;
    END;

-- Test out trigger!
-- Enter new row into existing nest_id
INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', '14eabaage01', 12.34, 56.78);

-- Check
.nullvalue -NULL-
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01'; -- Nice!

-- Enter new row using nest_id that is not existing
INSERT INTO Bird_eggs
    (Book_page, Year, Site, Nest_ID, Length, Width)
    VALUES ('b14.6', 2014, 'eaba', 'test', 12.34, 56.78);

-- Check that egg_num is 1
SELECT * FROM Bird_eggs WHERE Nest_ID = 'test'; -- Nice!

---------------------------------------------------------------------

-- PART 2
DROP TRIGGER egg_filler;

-- Create trigger, adding values for book page, year, and site
CREATE TRIGGER egg_filler
    AFTER INSERT ON Bird_eggs
    FOR EACH ROW
    BEGIN

        -- Set Egg_num
        UPDATE Bird_eggs
        SET Egg_num = (
            SELECT IFNULL (MAX(Egg_num), 0) + 1  -- If egg_num is null, treat and 0. Then add 1 to get next egg number
            FROM Bird_eggs
            WHERE Nest_ID = new.Nest_ID AND Egg_num IS NOT NULL)
        WHERE Nest_ID = new.Nest_ID AND Egg_num IS NULL;

        -- Set Book_page
        UPDATE Bird_eggs
        SET Book_page = (
            SELECT Book_page
            FROM Bird_nests
            WHERE Nest_ID = NEW.Nest_ID) -- Each unique nest_id is on the same book page
        WHERE Nest_ID = NEW.Nest_ID AND Book_page IS NULL;

        -- Set Year
        UPDATE Bird_eggs
        SET Year = (
            SELECT Year
            FROM Bird_nests
            WHERE Nest_ID = NEW.Nest_ID) -- All unique nest_ids will share the same year
        WHERE Nest_ID = NEW.Nest_ID AND Year IS NULL;

        -- Set Site
        UPDATE Bird_eggs
        SET Site = (
            SELECT Site
            FROM Bird_nests
            WHERE Nest_ID = NEW.Nest_ID) -- All unique nest_ids will be at the same site
        WHERE Nest_ID = NEW.Nest_ID AND Site IS NULL;
    END;

-- Enter new row
INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('14eabaage01', 12.34, 56.78);
-- Check
SELECT * FROM Bird_eggs WHERE Nest_ID = '14eabaage01'; -- Nice!

-- What if I make a new Nest_ID?
INSERT INTO Bird_eggs
    (Nest_ID, Length, Width)
    VALUES ('newid', 12.34, 56.78);
--Check
SELECT * FROM Bird_eggs WHERE Nest_ID = 'newid';
-- Makes sense that it would leave book_page, year, and site blank. 
-- If you were adding a new nest, you would want to add the rest of the information that goes with it as well.


