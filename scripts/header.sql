CREATE FUNCTION pg_temp.f_migrate(_next_revision VARCHAR)
    RETURNS VOID AS 
$func$
DECLARE new_revision VARCHAR;
BEGIN
