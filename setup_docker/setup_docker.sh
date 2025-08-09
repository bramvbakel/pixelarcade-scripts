#!/bin/bash
set -e

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
  echo "Please do not run this script as root. Use a regular user with sudo privileges."
  exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo apt update || { echo "apt update failed"; exit 1; }

# Upgrade installed packages
echo "Upgrading installed packages..."
sudo apt upgrade -y || { echo "apt upgrade failed"; exit 1; }

# Check if Docker is already installed
if command -v docker &> /dev/null; then
  echo "Docker is already installed. Skipping installation."
else
  # Install Docker and Docker Compose
  echo "Installing Docker and Docker Compose..."
  sudo apt install -y docker.io docker-compose || { echo "Docker installation failed"; exit 1; }
fi

# Add current user to the docker group (if not already a member)
if groups $USER | grep &>/dev/null '\bdocker\b'; then
  echo "User $USER is already in the docker group."
else
  echo "Adding current user to the docker group..."
  sudo usermod -aG docker $USER
  ADDED_TO_GROUP=1
fi

# Set time zone to Europe/Amsterdam
echo "Setting time zone to Europe/Amsterdam..."
sudo timedatectl set-timezone Europe/Amsterdam || { echo "Failed to set timezone"; exit 1; }

# Enable and start Docker service
echo "Enabling and starting Docker service..."
sudo systemctl enable docker || { echo "Failed to enable Docker service"; exit 1; }
sudo systemctl start docker || { echo "Failed to start Docker service"; exit 1; }

# Final message
echo "\n---"
echo "Setup complete!"
if [ "$ADDED_TO_GROUP" = "1" ]; then
  echo "You were added to the docker group. Please log out and log back in (or reboot) for group changes to take effect."
else
  echo "You may need to log out and log back in for docker group changes to take effect if this is your first time running this script."
fi
echo "Docker version: $(docker --version 2>/dev/null || echo 'not available')"