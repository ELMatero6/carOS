#!/bin/bash
set -e

echo "[CarOS] Starting installation..."

# Update package lists
sudo apt-get update -y

# Example: install some basics
sudo apt-get install -y curl htop

# You can add more setup steps here
# e.g., pip install -r requirements.txt
# or systemd service installs

echo "[CarOS] Installation complete!"
echo "Hello world"
