#!/bin/bash

BACKUP_DIR="/home/saltchicken/Sync/postgres-backups"
DATE=$(date +"%Y-%m-%d_%H-%M")
DATABASES=$(psql -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';")
FILENAME="db_backup_$DATE.sql.gz"

for DB in $DATABASES; do
    # Clean up whitespace
    DB=$(echo $DB | xargs)

    FILENAME="${DB}_${DATE}.dump"

    # Dump using Custom Format (-Fc) which enables pg_restore magic
    echo "Backing up $DB..."
    pg_dump -Fc "$DB" > "$BACKUP_DIR/$FILENAME"
done

# 4. Delete backups older than 7 days
find "$BACKUP_DIR" -type f -name "*.dump" -mtime +7 -delete
