#!/bin/bash

# Redirect all output and errors to a log file
exec > >(tee -a /var/log/startup-script.log) 2>&1
set -euo pipefail

echo "[INFO] Starting user-data script at $(date)"

# Backup sshd_config before modifying
echo "[INFO] Backing up /etc/ssh/sshd_config"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Enable password authentication
echo "[INFO] Enabling PasswordAuthentication in sshd_config"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config || true
sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config || true
sed -i 's/^#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config || true

# Set ec2-user password
echo "[INFO] Setting password for ec2-user"
echo 'ec2-user:p@55w0rd-123' | chpasswd

# Restart sshd
echo "[INFO] Restarting sshd"
systemctl restart sshd

# Validate
echo "[INFO] Validating SSH port and settings"
sshd -t || { echo "[ERROR] sshd config test failed"; shutdown -h now; }

grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config || { echo "[ERROR] PasswordAuthentication not enabled"; shutdown -h now; }
grep -q "^UsePAM yes" /etc/ssh/sshd_config || { echo "[ERROR] UsePAM not enabled"; shutdown -h now; }

echo "[INFO] installing telnet"
sudo yum install -y telnet

echo "[SUCCESS] Startup script completed at $(date)"