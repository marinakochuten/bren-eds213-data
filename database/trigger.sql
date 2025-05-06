.mode table

SELECT * FROM Species;

-- The problem weere going to try and fix
INSERT INTO Species VALUES ('abcd', 'thing1', '', 'Study species');

-- Time to create trigger
CREATE TRIGGER Fix_up_species
AFTER INSERT ON Species
FOR EACH ROW
BEGIN
    UPDATE Species
     SET Scientific_name = NULL
     WHERE Code = new.Code AND Scientific_name = '';
END;

-- Let's test it
INSERT INTO Species
    VALUES ('efgh', 'thing2', '', 'Study species');

.nullvalue -NULL-

SELECT * FROM Species;