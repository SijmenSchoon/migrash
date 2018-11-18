
    -- Sanity checks
    SELECT "revision" INTO new_revision FROM "revision" LIMIT 1;

    IF (new_revision = _next_revision) THEN
        RAISE EXCEPTION 'Script did not increment revision.';
    END IF;

    IF (char_length(new_revision) != 8) THEN
        RAISE EXCEPTION 'New revision should be 8 characters.';
    END IF;
END
$func$ LANGUAGE plpgsql;

SELECT pg_temp.f_migrate(:revision::varchar);