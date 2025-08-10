#!/bin/bash
set -e

# Log file setup
LOG_FILE="$(dirname "$0")/docker_volume_backup.log"
LOG_DATE_FORMAT="%d-%m-%Y %H:%M:%S"

# Forces log file to last delete lines if it exists and is too long
if [ -f "$LOG_FILE" ] && [ $(wc -l < "$LOG_FILE") -gt 1000 ]; then
  tail -n 1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

exec >> "$LOG_FILE" 2>&1

echo "\n--- $(date +"$LOG_DATE_FORMAT") Starting backup run..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "[ERROR] Docker is not installed. Please install Docker first."
  exit 1
fi

# Load environment variables from .env if it exists
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

# Require BACKUP_DIR to be set in .env
if [ -z "$BACKUP_DIR" ]; then
  echo "[ERROR] BACKUP_DIR is not set. Please set it in the .env file."
  exit 1
fi

# Require DOCKER_VOLUME to be set in .env
if [ -z "$DOCKER_VOLUME" ]; then
  echo "[ERROR] DOCKER_VOLUME is not set. Please set it in the .env file."
  exit 1
fi

# Require BACKUP_NAME to be set in .env
if [ -z "$BACKUP_NAME" ]; then
  echo "[ERROR] BACKUP_NAME is not set. Please set it in the .env file."
  exit 1
fi

# Set default for BACKUP_KEEP_COUNT if not set
if [ -z "$BACKUP_KEEP_COUNT" ]; then
  BACKUP_KEEP_COUNT=7
fi

# Set default for BACKUP_DATE_FORMAT if not set
if [ -z "$BACKUP_DATE_FORMAT" ]; then
  BACKUP_DATE_FORMAT="%d-%m-%Y"
fi

# Check if backup directory is writable (or create it)
if [ ! -w "$BACKUP_DIR" ]; then
  echo "[INFO] Backup directory $BACKUP_DIR is not writable or does not exist. Attempting to create it..."
  mkdir -p "$BACKUP_DIR" || { echo "[ERROR] Failed to create backup directory."; exit 1; }
fi

# Check if Docker volume exists
if ! docker volume inspect "$DOCKER_VOLUME" &>/dev/null; then
  echo "[ERROR] Docker volume '$DOCKER_VOLUME' does not exist."
  exit 1
fi

# Set date using configurable format
DATE=$(date +"$BACKUP_DATE_FORMAT")

# Remove old backups, keep only the newest BACKUP_KEEP_COUNT
BACKUP_PATTERN="$BACKUP_DIR/${BACKUP_NAME}-*.tar"
BACKUP_FILES=( $(ls -1t $BACKUP_PATTERN 2>/dev/null) )
if [ ${#BACKUP_FILES[@]} -gt $BACKUP_KEEP_COUNT ]; then
  echo "[INFO] Keeping only the $BACKUP_KEEP_COUNT most recent backups. Deleting older ones..."
  for ((i=BACKUP_KEEP_COUNT; i<${#BACKUP_FILES[@]}; i++)); do
    echo "[INFO] Deleting ${BACKUP_FILES[$i]}"
    rm -f "${BACKUP_FILES[$i]}"
  done
fi

# Perform backup
echo "[INFO] Attempting to backup the docker volume..."
if docker run --rm \
  -v "$DOCKER_VOLUME":/volume \
  -v "$BACKUP_DIR":/backup \
  busybox \
  tar cf "/backup/${BACKUP_NAME}-$DATE.tar" -C /volume .
then
  echo "[SUCCESS] Backup was successful."
  BACKUP_STATUS=0
else
  echo "[ERROR] Backup failed."
  BACKUP_STATUS=1
fi

# Final message
if [ $BACKUP_STATUS -eq 0 ]; then
  echo "[SUCCESS] Backup completed successfully: $BACKUP_DIR/${BACKUP_NAME}-$DATE.tar"
else
  echo "[ERROR] Backup failed. Please check the error messages above."
fi