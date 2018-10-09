## export latest


db=$1
u=$2

psql -U $2 -d $1 < tables.sql

