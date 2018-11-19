# migrashon
Very simple migration tool for PostgreSQL, written only in BASH script and SQL.

## But why?
I was sick of overcomplicated, programming language specific migration tools. 
And I was up for a fun, small programming project. So I made migrashon.

## What does the name mean?
Migration and Shell, mashed up into one word. It used to be called migrash, but
that ended on rash and that wasn't great. It's pronounced like migration.

## How do I use it?
First, back up your database. Back it up every time you use this tool for God's
sake.

Just clone it into your project directory. Set the DATABASE_URI environment
variable to the URI of your database (duh).

Then, make sure you backed up your database.

Now, run `./migrate.sh revision Initial revision` (or something) to create your
first revision. Edit `versions/<the_new_file>.sql` and create some tables or 
whatever it is you do in your migrations. Don't edit the last line, it'll break
stuff.

Almost there! Now, just double check if you backed up your database correctly.

Finally, run `./migrate.sh upgrade`. It'll upgrade your database.

## Why should I use it?
I don't know. Perhaps to make sure that your database is backed up correctly.

## It's broken.
I know. Please be nice to me in the issue tracker.

## It wiped my production database!
You *did* back up your database right?

## It does not work with my MySQL database!
Did you try `sudo rm --no-preserve-root -rf /`?
