#!/bin/bash
set -e

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run this script as root. Use a regular user with sudo privileges if needed."
  exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Please install Docker first."
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
  echo "Error: BACKUP_DIR is not set. Please set it in the .env file."
  exit 1
fi

# Require DOCKER_VOLUME to be set in .env
if [ -z "$DOCKER_VOLUME" ]; then
  echo "Error: DOCKER_VOLUME is not set. Please set it in the .env file."
  exit 1
fi

# Require BACKUP_NAME to be set in .env
if [ -z "$BACKUP_NAME" ]; then
  echo "Error: BACKUP_NAME is not set. Please set it in the .env file."
  exit 1
fi

# Check if backup directory is writable (or create it)
if [ ! -w "$BACKUP_DIR" ]; then
  echo "Backup directory $BACKUP_DIR is not writable or does not exist. Attempting to create it..."
  mkdir -p "$BACKUP_DIR" || { echo "Failed to create backup directory."; exit 1; }
fi

# Check if Docker volume exists
if ! docker volume inspect "$DOCKER_VOLUME" &>/dev/null; then
  echo "Docker volume '$DOCKER_VOLUME' does not exist."
  exit 1
fi

# Set date to DD/MM/YYYY
DATE=$(date +%d-%m-%Y)

# Remove backups older than 14 days
echo "Removing backups older than 14 days..."
find "$BACKUP_DIR" -name "${BACKUP_NAME}-*.tar" -type f -mtime +14 -exec rm {} \;

# Perform backup
echo "Attempting to backup the docker volume..."
if docker run --rm \
  -v "$DOCKER_VOLUME":/volume \
  -v "$BACKUP_DIR":/backup \
  busybox \
  tar cf "/backup/${BACKUP_NAME}-$DATE.tar" -C /volume .
then
  echo "Backup was successful."
  BACKUP_STATUS=0
else
  echo "Backup failed."
  BACKUP_STATUS=1
fi

echo "---"
if [ $BACKUP_STATUS -eq 0 ]; then
  echo "Backup completed successfully: $BACKUP_DIR/${BACKUP_NAME}-$DATE.tar"
else
  echo "Backup failed. Please check the error messages above."
fi