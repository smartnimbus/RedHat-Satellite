#!/bin/bash
# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/security_hardening/index
# chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/pdf/security_hardening/Red_Hat_Enterprise_Linux-8-Security_hardening-en-US.pdf
# https://medium.com/@manigandans206/rhel-cis-benchmark-hardening-and-building-ami-using-hashicorp-packer-fe30015f94cf
# Disable root login
echo "Disabling root login..."
passwd -l root

# Enable firewall and open necessary ports
echo "Configuring firewall..."
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Update all packages
yum update -y
