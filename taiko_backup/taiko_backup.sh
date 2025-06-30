#!/bin/bash

# European date format
DATE=$(date +%d-%m-%Y)

# Backup location
BACKUP_DIR="/mnt/nas_backups/databases/taiko"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Remove backups older than 14 days
find "$BACKUP_DIR" -name "taiko_database-*.tar" -type f -mtime +14 -exec rm {} \;

# Perform backup
docker run --rm \
  -v taiko-database:/volume \
  -v "$BACKUP_DIR":/backup \
  busybox \
  tar cf "/backup/taiko_database-$DATE.tar" -C /volume .