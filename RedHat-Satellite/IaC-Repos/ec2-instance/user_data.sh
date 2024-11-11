#!/bin/bash

echo "Installing python3 and AWS SSM agent"

# Check if python3 is already installed
if command -v python3 &>/dev/null; then
    echo "python3 already installed on this server"
else
    echo "installing python3..."
    sudo dnf install python3
fi

# Check if Amazon SSM agent is already installed
cd /tmp
if ! rpm -q amazon-ssm-agent; then
    echo "AWS SSM agent is not installed. Installing now..."
    # Install Amazon SSM agent
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
else
    echo "AWS SSM agent is already installed."
fi
    
# Check if Amazon SSM agent is running
if sudo systemctl is-active --quiet amazon-ssm-agent; then
    echo "Amazon SSM agent is running!"
else
    echo "Amazon SSM agent is not running. Starting the agent..."
    # Start the Amazon SSM agent service
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
fi

# Check again if the Amazon SSM agent is now running
if sudo systemctl is-active --quiet amazon-ssm-agent; then
    echo "Amazon SSM agent is now running!"
else
    echo "Failed to start Amazon SSM agent."
fi