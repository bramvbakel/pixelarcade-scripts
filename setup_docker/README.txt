
# Docker Environment Setup Script

This script (`setup_docker.sh`) automates the setup of an Ubuntu system for Docker development. It installs Docker, Docker Compose, configures user permissions, sets the time zone, and ensures Docker starts on boot.

## How It Works

1. **Update Package Lists**
	- Runs `apt update` to refresh the list of available packages.

2. **Upgrade Installed Packages**
	- Runs `apt upgrade -y` to upgrade all installed packages to their latest versions.

3. **Install Docker and Docker Compose**
	- Installs both Docker Engine (`docker.io`) and Docker Compose (`docker-compose`).

4. **Add User to Docker Group**
	- Adds the current user to the `docker` group, allowing Docker commands without `sudo` (requires logout/login to take effect).

5. **Set Time Zone**
	- Sets the system time zone to `Europe/Amsterdam` using `timedatectl`.

6. **Enable and Start Docker Service**
	- Enables Docker to start on boot and starts the Docker service immediately.

## Usage

1. Make the script executable:
	```bash
	chmod +x setup_docker.sh
	```
2. Run the script:
	```bash
	./setup_docker.sh
	```

## Notes
- You may need to log out and log back in for the Docker group changes to take effect.
- The script must be run with a user that has `sudo` privileges.
- Adjust the time zone in the script if you are not in Europe/Amsterdam.

## Troubleshooting
- If you cannot run Docker without `sudo` after running the script, log out and log back in, or reboot your system.
- If Docker fails to start, check the service status with `sudo systemctl status docker`.

---
