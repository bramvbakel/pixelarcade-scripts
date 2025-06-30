# Ubuntu Setup Script
This script automates the basic setup of an Ubuntu system for Docker development.  

## What it does
- Updates the package list (`apt update`)  
- Upgrades installed packages (`apt upgrade -y`)  
- Installs Docker (`docker.io`) and Docker Compose (`docker-compose`)  
- Adds the current user to the `docker` group (allows running Docker without `sudo`)  
- Sets the system time zone to `Europe/Amsterdam`  
- Enables and starts the Docker service  

## Usage
Make the script executable and run it:

chmod +x setup-ubuntu.sh
./setup-ubuntu.sh
