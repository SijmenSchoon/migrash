#!/bin/bash

# Exit on any error
set -e

# Change to the script directory
cd "${0%/*}"

FIRST_REVISION='00000000'
PSQL="psql $DATABASE_URI -v ON_ERROR_STOP=1 -Xqt"
export PGOPTIONS='--client-min-messages=warning'

function _initialize {
    $PSQL -v "first_revision='$FIRST_REVISION'" -f 'scripts/initialize.sql';
}

function get_next_revision {
    next_revision=$($PSQL -c 'SELECT "revision" FROM "revision"')
    echo $next_revision
}

function _get_revision_file {
    echo "versions/*_$1_*.sql"
}

function initialize {
    _initialize
    echo "Database initialized."
}

function upgrade {
    _initialize

    next_revision=$(get_next_revision)
    file=$(_get_revision_file $next_revision)
    if [ ! -e $file ]; then
        echo "Already at the latest revision."
        return
    fi

    echo 'Migrating...'
    while true; do
        pattern=$(_get_revision_file $next_revision)
        if [ ! -e $pattern ]; then
            break
        fi

        echo "Running $(ls $pattern)"
        cat "scripts/header.sql" $pattern "scripts/footer.sql" | \
            $PSQL -v "revision='$next_revision'" > /dev/null

        next_revision=$(get_next_revision)
    done

    echo 'Done.'
}

function revision {
    function _generate_revision_code {
        tr -dc 'a-z0-9' < /dev/urandom | head -c8
    }

    _initialize

    date=$(date '+%Y%M%d-%H%M')
    name=$(sed 's/[^[:alnum:]]\+/-/g' <<< "${1,,}")

    # Make sure that the database is up to date.
    revision=$(get_next_revision)
    if [ -e $(_get_revision_file $revision) ]; then
        echo "Database out of date. Please upgrade first."
        return 1
    fi

    # Generate a new revision code, and check if it's not duplicate.
    next_revision="00000000"
    while [ -e $(_get_revision_file $next_revision) ]; do
        next_revision=$(_generate_revision_code)
    done

    cat << EOF > "versions/${date}_${revision}_${name}.sql"
-- START OF MIGRATION --
-- Put your migration here.

-- END OF MIGRATION --

-- The revision to use for the next migration. Don't touch this.
UPDATE "revision" SET "revision"='$next_revision';
EOF
}

function default {
    echo "Unknown command '$1'."
    return 1
}

case $1 in
    initialize) initialize ;;
    init) initialize ;;

    upgrade) upgrade ;;
    revision) revision "${*:2}" ;;

    current) get_next_revision ;;

    *) default $1 ;;
esac