#!/bin/bash

# Exit on error
set -e

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

echo "[*] Setting up SSH access for root using GitHub public keys..."

# Create the .ssh directory
mkdir -p /root/.ssh

# Download public keys from GitHub account
curl -sS https://github.com/iamjoshgilman.keys -o /root/.ssh/authorized_keys

# Set correct permissions
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

# Update sshd_config to allow key-based root login
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup original config
if [ ! -f "${SSHD_CONFIG}.bak" ]; then
  cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"
  echo "[*] Backed up original sshd_config to sshd_config.bak"
fi

# Enforce secure SSH settings
sed -i 's/^#\?\(PermitRootLogin\).*/\1 prohibit-password/' "$SSHD_CONFIG"
sed -i 's/^#\?\(PasswordAuthentication\).*/\1 no/' "$SSHD_CONFIG"
sed -i 's/^#\?\(PubkeyAuthentication\).*/\1 yes/' "$SSHD_CONFIG"

# Restart SSH service
echo "[*] Restarting SSH service..."
systemctl restart sshd

echo "[✔] SSH key-based root login setup complete!"
