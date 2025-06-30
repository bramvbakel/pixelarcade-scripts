#!/bin/bash
set -e

echo "Updating package lists..."
sudo apt update

echo "pgrading installed packages..."
sudo apt upgrade -y

echo "Installing Docker and Docker Compose..."
sudo apt install -y docker.io docker-compose

echo "Adding current user to the docker group..."
sudo usermod -aG docker $USER

echo "Setting time zone to Europe/Amsterdam..."
sudo timedatectl set-timezone Europe/Amsterdam

echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Setup complete! You may need to log out and log back in for docker group changes to take effect."