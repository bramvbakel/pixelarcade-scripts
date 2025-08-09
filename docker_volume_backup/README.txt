# Docker Volume Backup Script

This script (`docker_volume_backup.sh`) automates the process of backing up a Docker volume to a specified backup directory. It is designed for Linux systems with Docker installed and can be used for local or network storage.

## How It Works

1. **Loads Configuration**  
   Reads all settings from a `.env` file (see below for configuration).
2. **Checks Requirements**  
   Ensures Docker is installed, the backup directory exists (or creates it), and the specified Docker volume exists.
3. **Creates a Timestamped Backup**  
   Uses Docker to run a temporary BusyBox container, creating a tar archive of the specified Docker volume. The backup file is named with a prefix and the current date.
4. **Backup Retention by File Count**  
   Keeps only the most recent number of backups as set by `BACKUP_KEEP_COUNT` in your `.env` file. Older backups are automatically deleted.
5. **Reports Success or Failure**  
   Prints a message indicating whether the backup was successful and the path to the backup file.

## Usage

1. Make sure you have Docker installed and running on your system.
2. Create your own `.env` file using the provided template:
   ```bash
   cp .env.example .env
   # Edit .env to set BACKUP_DIR, DOCKER_VOLUME, BACKUP_NAME, and BACKUP_KEEP_COUNT with your own values
   ```
3. Ensure the backup directory you set in `.env` is accessible and writable.
4. Run the script with:
   ```bash
   bash docker_volume_backup.sh
   ```
   Or make it executable and run directly:
   ```bash
   chmod +x docker_volume_backup.sh
   ./docker_volume_backup.sh
   ```

## Environment Variables

Create a `.env` file in the same directory as the script with the following variables:

```env
BACKUP_DIR="/your/backup/location"
DOCKER_VOLUME="your-docker-volume-name"
BACKUP_NAME="your-backup-name-prefix"
BACKUP_KEEP_COUNT=7
```

You can use `.env.example` as a template.

## Notes
- The script must be run with sufficient permissions to access Docker and the backup directory.
- All configuration is handled via the `.env` file; do not edit sensitive or environment-specific values in the script.
- The script will automatically keep only the most recent backups as specified by `BACKUP_KEEP_COUNT`.

## Troubleshooting
- If you see a "Backup failed." message, check Docker permissions, volume names, and backup directory access.
- Ensure the NAS or backup location is mounted and available before running the script.

---
