-- Create the "revision" table if it does not exist yet.
CREATE TABLE IF NOT EXISTS "revision"
    ("revision" VARCHAR(8) PRIMARY KEY);

-- Set the revision to FIRST_REVISION if it does not exist.
INSERT INTO "revision" ("revision") SELECT :first_revision 
    WHERE NOT EXISTS (SELECT "revision" FROM "revision");