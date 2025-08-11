#!/bin/bash
set -e

# Log file setup
LOG_FILE="$(dirname "$0")/install_docker_ubuntu.log"
LOG_DATE_FORMAT="%d-%m-%Y %H:%M:%S"

# Truncate log file to last 1000 lines if too long
if [ -f "$LOG_FILE" ] && [ $(wc -l < "$LOG_FILE") -gt 1000 ]; then
  tail -n 1000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

exec >> "$LOG_FILE" 2>&1

echo -e "\n--- $(date +"$LOG_DATE_FORMAT") Starting Docker install run..."

# Load environment variables from .env if it exists
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
  echo "[INFO] Loaded environment variables from .env"
fi

# Prevent running as root
if [ "$EUID" -eq 0 ]; then
  echo "[ERROR] Please do not run this script as root. Use a regular user with sudo privileges."
  exit 1
fi

# Require TIMEZONE to be set in .env
if [ -z "$TIMEZONE" ]; then
  echo "[ERROR] TIMEZONE is not set. Please set it in the .env file."
  exit 1
fi

echo "[INFO] Updating package lists..."
sudo apt update || { echo "[ERROR] apt update failed"; exit 1; }

echo "[INFO] Upgrading installed packages..."
sudo apt upgrade -y || { echo "[ERROR] apt upgrade failed"; exit 1; }

# Check if Docker is already installed
if command -v docker &> /dev/null; then
  echo "[INFO] Docker is already installed. Skipping installation."
else
  echo "[INFO] Installing Docker and Docker Compose..."
  sudo apt install -y docker.io docker-compose || { echo "[ERROR] Docker installation failed"; exit 1; }
fi

# Add current user to the docker group (if not already a member)
if groups $USER | grep &>/dev/null '\bdocker\b'; then
  echo "[INFO] User $USER is already in the docker group."
else
  echo "[INFO] Adding current user to the docker group..."
  sudo usermod -aG docker $USER
  ADDED_TO_GROUP=1
fi

echo "[INFO] Setting time zone to $TIMEZONE..."
sudo timedatectl set-timezone "$TIMEZONE" || { echo "[ERROR] Failed to set timezone"; exit 1; }

echo "[INFO] Enabling and starting Docker service..."
sudo systemctl enable docker || { echo "[ERROR] Failed to enable Docker service"; exit 1; }
sudo systemctl start docker || { echo "[ERROR] Failed to start Docker service"; exit 1; }

echo "[SUCCESS] Setup complete!"
if [ "$ADDED_TO_GROUP" = "1" ]; then
  echo "[INFO] You were added to the docker group. Please log out and log back in (or reboot) for group changes to take effect."
else
  echo "[INFO] You may need to log out and log back in for docker group changes to take effect if this is your first time running this script."
fi
echo "[INFO] Docker version: $(docker --version 2>/dev/null || echo 'not available')"