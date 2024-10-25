#!/bin/bash
# Install NTP
echo "Installing NTP..."
yum install -y chrony
systemctl enable chronyd
systemctl start chronyd

# Install monitoring tools (e.g., collectd)
echo "Installing monitoring tools..."
yum install -y collectd
systemctl enable collectd
systemctl start collectd
