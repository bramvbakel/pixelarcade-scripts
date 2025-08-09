

# Docker Volume Backup Script

This script (`docker_volume_backup.sh`) automates the process of backing up any Docker volume to a specified backup directory. It is designed to be run on a Linux system with Docker installed and access to the target backup location (e.g., a mounted NAS or local folder).

## How It Works

1. **Set Backup Location**
	- The script loads the backup directory from the `.env` file (see below for configuration).

2. **Set Date Format**
	- The backup filename includes the current date in `DD-MM-YYYY` format for easy identification.

3. **Ensure Backup Directory Exists**
	- The script creates the backup directory if it does not already exist.

4. **Remove Old Backups**
	- Any backup files older than 14 days in the backup directory are automatically deleted to save space.

5. **Perform the Backup**
	- The script uses Docker to run a temporary BusyBox container, which creates a tar archive of the specified Docker volume and saves it to the backup directory with the current date in the filename.

6. **Check Backup Success**
	- After the backup command runs, the script checks if it was successful and prints a message indicating success or failure.

## Usage

1. Make sure you have Docker installed and running on your system.

2. Create your own `.env` file using the provided template:
	```bash
	cp .env.example .env
	# Edit .env to set BACKUP_DIR and DOCKER_VOLUME with your own values
	```
3. Ensure the backup directory you set in `.env` is accessible and writable.
4. Run the script with:
	```bash
	bash docker_volume_backup.sh
	```
	or make it executable and run directly:
	```bash
	chmod +x docker_volume_backup.sh
	./docker_volume_backup.sh
	```

## Notes
- The script must be run with sufficient permissions to access Docker and the backup directory.
- Do not edit sensitive or environment-specific values in the script. Use the `.env` file for configuration.
## Environment Variables

Create a `.env` file in the same directory as the script with the following variables:

```
BACKUP_DIR="/your/backup/location"
DOCKER_VOLUME="your-docker-volume-name"
```

You can use `.env.example` as a template.

- The script will automatically clean up old backups (older than 14 days).

## Troubleshooting
- If you see a "Backup failed." message, check Docker permissions, volume names, and backup directory access.
- Ensure the NAS or backup location is mounted and available before running the script.

---
