# Taiko Database Backup Script
This script backs up the `taiko-database` Docker volume and saves it to a mounted NAS location. It also deletes backups older than 14 days.

## What it does
1. Sets the date in `DD-MM-YYYY` format.
2. Defines the backup folder: `/mnt/nas_backups/databases/taiko`
3. Creates the backup folder if it doesn't exist.
4. Deletes `.tar` backups older than 14 days.
5. Runs a temporary `busybox` container to create a `.tar` backup of the Docker volume.

## Requirements
- Docker
- A Docker volume named `taiko-database`
- A mounted NAS path at `/mnt/nas_backups/databases/taiko`

## How to use
Make the script executable:
chmod +x backup_taiko.sh
./backup_taiko.sh
