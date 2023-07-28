#!/bin/bash

# Database Credentials
DB_USER=""
DB_PASS=""
DB_NAME=""

# Maximum number of backups to keep
MAX_BACKUPS=3

# Backup directory on the external drive
INTERNAL_BACKUP_DIR="/mnt/backup_drive/db_backups"
EXTERNAL_BACKUP_DIR="/media/external_drive/db_backups"

# Timestamp for the backup file
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Backup command
mysqldump -u "$DB_USER" "$DB_NAME" > "$INTERNAL_BACKUP_DIR"/dbname_backup_"$TIMESTAMP".sql

# Remove old backups if the count exceeds MAX_BACKUPS
cd "$INTERNAL_BACKUP_DIR"
BACKUP_FILES=($(ls -1tr | grep '^dbname_backup_[0-9]\{14\}\.sql$'))

BACKUP_COUNT=${#BACKUP_FILES[@]}
if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    # Calculate how many files to remove
    REMOVE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))

    # Loop through the files and remove the older ones
    for ((i=0; i<REMOVE_COUNT; i++)); do
        rm -f "${BACKUP_FILES[$i]}"
    done
fi

